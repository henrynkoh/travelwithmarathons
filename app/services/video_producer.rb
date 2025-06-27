require 'streamio-ffmpeg'
require 'aws-sdk-s3'

class VideoProducer
  def initialize
    @s3_client = Aws::S3::Client.new(
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    ) if ENV['AWS_ACCESS_KEY_ID']
  end

  def produce(video)
    # Generate script for TTS
    script = generate_script(video)
    
    # Generate audio from script
    audio_path = generate_audio(script)
    
    # Download stock footage
    video_path = download_stock_footage(video.travel_tip.city)
    
    # Combine video and audio
    final_video_path = combine_video_audio(video_path, audio_path)
    
    # Generate thumbnail
    thumbnail_path = generate_thumbnail(final_video_path)
    
    # Upload to S3 if configured
    if @s3_client
      s3_video_path = upload_to_s3(final_video_path, "videos/#{video.id}.mp4")
      s3_thumbnail_path = upload_to_s3(thumbnail_path, "thumbnails/#{video.id}.jpg")
      
      # Update video record with S3 paths
      video.update!(
        video_path: s3_video_path,
        thumbnail_path: s3_thumbnail_path,
        status: 'produced'
      )
    else
      # Store locally
      local_video_path = Rails.root.join('public', 'videos', "#{video.id}.mp4")
      local_thumbnail_path = Rails.root.join('public', 'thumbnails', "#{video.id}.jpg")
      
      FileUtils.mv(final_video_path, local_video_path)
      FileUtils.mv(thumbnail_path, local_thumbnail_path)
      
      video.update!(
        video_path: "/videos/#{video.id}.mp4",
        thumbnail_path: "/thumbnails/#{video.id}.jpg",
        status: 'produced'
      )
    end
    
    # Cleanup temporary files
    cleanup_temp_files([audio_path, video_path, final_video_path, thumbnail_path])
  rescue StandardError => e
    video.mark_as_failed!
    Rails.logger.error("Video production failed for #{video.id}: #{e.message}")
    raise e
  end

  private

  def generate_script(video)
    travel_tip = video.travel_tip
    <<~SCRIPT
      #{travel_tip.city} Marathon Adventure!
      
      #{travel_tip.itinerary.split("\n").first(3).join("\n")}
      
      #{travel_tip.case_study.split("\n").first(2).join("\n")}
      
      Subscribe for more travel tips!
      
      *For informational purposes only. Please consult a travel advisor.
    SCRIPT
  end

  def generate_audio(script)
    output_path = Rails.root.join('tmp', "#{SecureRandom.hex(8)}.mp3")
    
    # Use system TTS for MVP
    system("say -v Samantha -o #{output_path} '#{script.gsub("'", ''')}'")
    
    output_path
  end

  def download_stock_footage(city)
    # For MVP, we'll use a placeholder video
    # In production, this would download from Pexels or similar
    Rails.root.join('lib', 'assets', 'stock_videos', 'placeholder.mp4')
  end

  def combine_video_audio(video_path, audio_path)
    output_path = Rails.root.join('tmp', "#{SecureRandom.hex(8)}.mp4")
    
    movie = FFMPEG::Movie.new(video_path)
    movie.transcode(output_path, %W(-i #{audio_path} -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 -shortest))
    
    output_path
  end

  def generate_thumbnail(video_path)
    output_path = Rails.root.join('tmp', "#{SecureRandom.hex(8)}.jpg")
    
    movie = FFMPEG::Movie.new(video_path)
    movie.screenshot(output_path, seek_time: 1)
    
    output_path
  end

  def upload_to_s3(file_path, s3_path)
    bucket = ENV['AWS_S3_BUCKET']
    
    File.open(file_path, 'rb') do |file|
      @s3_client.put_object(
        bucket: bucket,
        key: s3_path,
        body: file,
        acl: 'public-read'
      )
    end
    
    "https://#{bucket}.s3.#{ENV['AWS_REGION']}.amazonaws.com/#{s3_path}"
  end

  def cleanup_temp_files(paths)
    paths.each do |path|
      File.delete(path) if path && File.exist?(path)
    end
  end
end 