class DashboardController < ApplicationController
  def index
    @travel_tips = TravelTip.includes(:videos).order(created_at: :desc)
    @videos = Video.includes(:travel_tip).order(created_at: :desc)
    @stats = {
      total_tips: TravelTip.count,
      total_videos: Video.count,
      pending_videos: Video.pending.count,
      uploaded_videos: Video.uploaded.count,
      failed_videos: Video.failed.count
    }
  end

  def approve_video
    video = Video.find(params[:id])
    video.approve!
    ProduceVideoJob.perform_later(video.id)
    redirect_to root_path, notice: 'Video approved for production'
  rescue StandardError => e
    redirect_to root_path, alert: "Error approving video: #{e.message}"
  end

  def retry_video
    video = Video.find(params[:id])
    video.update!(status: 'pending')
    redirect_to root_path, notice: 'Video queued for retry'
  rescue StandardError => e
    redirect_to root_path, alert: "Error retrying video: #{e.message}"
  end

  def crawl
    CrawlTravelTipsJob.perform_later
    redirect_to root_path, notice: 'Travel tips crawl scheduled'
  rescue StandardError => e
    redirect_to root_path, alert: "Error scheduling crawl: #{e.message}"
  end
end 