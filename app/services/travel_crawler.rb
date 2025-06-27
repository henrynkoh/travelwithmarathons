require 'nokogiri'
require 'httparty'

class TravelCrawler
  MARATHON_CITIES = {
    'Boston' => 'Boston Marathon',
    'Vancouver' => 'Vancouver Marathon',
    'Tokyo' => 'Tokyo Marathon',
    'London' => 'London Marathon',
    'Berlin' => 'Berlin Marathon',
    'New York' => 'New York City Marathon',
    'Chicago' => 'Chicago Marathon',
    'Paris' => 'Paris Marathon',
    'Seoul' => 'Seoul Marathon',
    'Sydney' => 'Sydney Marathon',
    'Honolulu' => 'Honolulu Marathon',
    'Cape Town' => 'Cape Town Marathon'
  }

  def crawl
    MARATHON_CITIES.each do |city, marathon|
      crawl_city_data(city, marathon)
    end
  rescue StandardError => e
    Rails.logger.error("Travel crawling failed: #{e.message}")
    raise e
  end

  private

  def crawl_city_data(city, marathon)
    # Skip if we already have this city's data
    return if TravelTip.exists?(city: city)

    # Get marathon website data
    marathon_url = get_marathon_url(city, marathon)
    
    # Get travel data from TripAdvisor
    travel_data = get_tripadvisor_data(city)
    
    # Get news sentiment
    sentiment = analyze_news_sentiment(city)

    # Create travel tip
    TravelTip.create!(
      city: city,
      marathon: marathon,
      source_url: marathon_url,
      sentiment: sentiment
    )
  rescue StandardError => e
    Rails.logger.error("Failed to crawl data for #{city}: #{e.message}")
  end

  def get_marathon_url(city, marathon)
    case city
    when 'Boston'
      'https://www.baa.org/races/boston-marathon'
    when 'Vancouver'
      'https://www.bmovanmarathon.ca'
    when 'Tokyo'
      'https://www.marathon.tokyo/en/'
    when 'London'
      'https://www.tcslondonmarathon.com'
    when 'Berlin'
      'https://www.bmw-berlin-marathon.com/en/'
    when 'New York'
      'https://www.nyrr.org/tcsnycmarathon'
    when 'Chicago'
      'https://www.chicagomarathon.com'
    when 'Paris'
      'https://www.schneiderelectricparismarathon.com/en/'
    when 'Seoul'
      'https://www.seoul-marathon.com/eng/'
    when 'Sydney'
      'https://sydneyrunningfestival.com.au'
    when 'Honolulu'
      'https://www.honolulumarathon.org'
    when 'Cape Town'
      'https://www.capetownmarathon.com'
    else
      "https://www.google.com/search?q=#{URI.encode_www_form_component(marathon)}"
    end
  end

  def get_tripadvisor_data(city)
    # This would use TripAdvisor's API or scrape their website
    # For MVP, we'll return placeholder data
    {
      attractions: ["Popular attractions in #{city}"],
      restaurants: ["Popular restaurants in #{city}"],
      hotels: ["Popular hotels in #{city}"]
    }
  end

  def analyze_news_sentiment(city)
    return 'positive' unless ENV['NEWSAPI_KEY']

    url = "https://newsapi.org/v2/everything"
    response = HTTParty.get(url, query: {
      q: "#{city} travel tourism",
      apiKey: ENV['NEWSAPI_KEY'],
      language: 'en',
      sortBy: 'relevancy',
      pageSize: 10
    })

    if response.success?
      articles = response['articles']
      # Simple sentiment analysis based on keywords
      positive_words = ['beautiful', 'amazing', 'excellent', 'wonderful', 'great', 'safe']
      negative_words = ['dangerous', 'unsafe', 'bad', 'avoid', 'terrible', 'poor']

      total_score = articles.sum do |article|
        text = "#{article['title']} #{article['description']}"
        positive_count = positive_words.count { |word| text.downcase.include?(word) }
        negative_count = negative_words.count { |word| text.downcase.include?(word) }
        positive_count - negative_count
      end

      total_score >= 0 ? 'positive' : 'negative'
    else
      'positive' # Default to positive if API fails
    end
  rescue StandardError => e
    Rails.logger.error("News API error: #{e.message}")
    'positive' # Default to positive on error
  end
end 