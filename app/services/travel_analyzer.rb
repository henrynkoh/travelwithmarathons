class TravelAnalyzer
  def analyze(travel_tip)
    itinerary = generate_itinerary(travel_tip)
    case_study = generate_case_study(travel_tip)
    
    travel_tip.update!(
      itinerary: itinerary,
      case_study: case_study
    )
  rescue StandardError => e
    Rails.logger.error("Travel analysis failed for #{travel_tip.city}: #{e.message}")
    raise e
  end

  private

  def generate_itinerary(travel_tip)
    # This would integrate with AI services in the future
    # For MVP, we'll use templates
    case travel_tip.city
    when 'Boston'
      <<~ITINERARY
        Pre-Marathon:
        - Book accommodation near Copley Square
        - Visit Boston Common and Public Garden
        - Carb-load at North End Italian restaurants
        - Pick up race packet at Marathon Expo

        Marathon Day:
        - Early shuttle to Hopkinton
        - Run the historic Boston Marathon route
        - Finish at Copley Square
        - Celebrate at Faneuil Hall

        Post-Marathon:
        - Recovery walk on Freedom Trail
        - Visit Fenway Park
        - Seafood dinner at Legal Harborside
        - Reflect at Boston Harbor
      ITINERARY
    when 'Vancouver'
      <<~ITINERARY
        Pre-Marathon:
        - Stay near Stanley Park
        - Explore Granville Island Market
        - Practice run on Seawall
        - Packet pickup at Convention Centre

        Marathon Day:
        - Start at Queen Elizabeth Park
        - Run through diverse neighborhoods
        - Finish at BC Place Stadium
        - Celebrate in Gastown

        Post-Marathon:
        - Relax at English Bay Beach
        - Visit Vancouver Aquarium
        - Dinner in Yaletown
        - Sunset at Grouse Mountain
      ITINERARY
    else
      <<~ITINERARY
        Pre-Marathon:
        - Research local accommodations
        - Plan transportation to start line
        - Visit local attractions
        - Attend race expo

        Marathon Day:
        - Early arrival at start line
        - Run #{travel_tip.marathon}
        - Post-race recovery
        - Local celebration

        Post-Marathon:
        - Light recovery activities
        - Cultural exploration
        - Local cuisine experience
        - Travel reflection
      ITINERARY
    end
  end

  def generate_case_study(travel_tip)
    # This would be AI-generated in the future
    # For MVP, we'll use templates
    case travel_tip.city
    when 'Boston'
      <<~CASE_STUDY
        Sarah, a first-time Boston Marathoner, saved $200 on her trip:
        - Booked accommodation 6 months in advance
        - Used public transport instead of taxis
        - Found local restaurant deals
        - Joined group tours for sightseeing
      CASE_STUDY
    when 'Vancouver'
      <<~CASE_STUDY
        Mike, an experienced runner, optimized his Vancouver trip:
        - Used hotel points for free stays
        - Bought groceries at Granville Market
        - Used bike share for city exploration
        - Found early-bird dining specials
      CASE_STUDY
    else
      <<~CASE_STUDY
        Tips for #{travel_tip.city} Marathon success:
        - Book travel early for better rates
        - Research local transportation
        - Look for package deals
        - Connect with local running groups
      CASE_STUDY
    end
  end
end 