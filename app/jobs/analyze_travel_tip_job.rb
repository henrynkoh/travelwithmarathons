class AnalyzeTravelTipJob < ApplicationJob
  queue_as :default

  def perform(travel_tip_id)
    Rails.logger.info "Starting analysis for travel tip #{travel_tip_id}"
    
    travel_tip = TravelTip.find(travel_tip_id)
    analyzer = TravelAnalyzer.new
    analyzer.analyze(travel_tip)
    
    # Create a video for the analyzed tip
    video = Video.create!(
      travel_tip: travel_tip,
      script: generate_initial_script(travel_tip),
      status: 'pending'
    )
    
    Rails.logger.info "Completed analysis for travel tip #{travel_tip_id}"
  rescue StandardError => e
    Rails.logger.error "Travel tip analysis failed for #{travel_tip_id}: #{e.message}"
    raise e
  end

  private

  def generate_initial_script(travel_tip)
    <<~SCRIPT
      #{travel_tip.city} Marathon Adventure!
      
      #{travel_tip.itinerary.split("\n").first(3).join("\n")}
      
      #{travel_tip.case_study.split("\n").first(2).join("\n")}
      
      Subscribe for more travel tips!
      
      *For informational purposes only. Please consult a travel advisor.
    SCRIPT
  end
end 