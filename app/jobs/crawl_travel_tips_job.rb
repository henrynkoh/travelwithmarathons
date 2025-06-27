class CrawlTravelTipsJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting travel tips crawl"
    
    crawler = TravelCrawler.new
    crawler.crawl
    
    # Schedule analysis for all unanalyzed tips
    TravelTip.where(itinerary: nil).find_each do |tip|
      AnalyzeTravelTipJob.perform_later(tip.id)
    end
    
    Rails.logger.info "Completed travel tips crawl"
  rescue StandardError => e
    Rails.logger.error "Travel tips crawl failed: #{e.message}"
    raise e
  end
end 