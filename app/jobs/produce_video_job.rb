class ProduceVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    Rails.logger.info "Starting video production for video #{video_id}"
    
    video = Video.find(video_id)
    return unless video.status == 'approved'
    
    producer = VideoProducer.new
    producer.produce(video)
    
    # Schedule upload if production was successful
    if video.status == 'produced'
      UploadVideoJob.perform_later(video.id)
    end
    
    Rails.logger.info "Completed video production for video #{video_id}"
  rescue StandardError => e
    Rails.logger.error "Video production failed for #{video_id}: #{e.message}"
    raise e
  end
end 