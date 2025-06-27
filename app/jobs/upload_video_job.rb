class UploadVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    Rails.logger.info "Starting YouTube upload for video #{video_id}"
    
    video = Video.find(video_id)
    return unless video.status == 'produced'
    
    uploader = YouTubeUploader.new
    uploader.upload(video)
    
    Rails.logger.info "Completed YouTube upload for video #{video_id}"
  rescue StandardError => e
    Rails.logger.error "YouTube upload failed for #{video_id}: #{e.message}"
    raise e
  end
end 