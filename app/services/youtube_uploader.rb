require 'google/apis/youtube_v3'

class YouTubeUploader
  def initialize
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.client_options.application_name = 'MarathonWanderer'
    @youtube.authorization = authorize
  end

  def upload(video)
    # Prepare video metadata
    metadata = {
      snippet: {
        title: generate_title(video),
        description: generate_description(video),
        tags: generate_tags(video),
        category_id: '19', # Travel & Events
        default_language: 'en'
      },
      status: {
        privacy_status: 'public',
        self_declared_made_for_kids: false
      }
    }

    # Upload video
    uploaded_video = @youtube.insert_video(
      'snippet,status',
      metadata,
      upload_source: video.video_path
    )

    # Update video record with YouTube ID
    video.update!(
      youtube_id: uploaded_video.id,
      status: 'uploaded'
    )
  rescue Google::Apis::Error => e
    video.mark_as_failed!
    Rails.logger.error("YouTube upload failed for #{video.id}: #{e.message}")
    raise e
  end

  private

  def authorize
    # Load credentials from environment or file
    if ENV['GOOGLE_APPLICATION_CREDENTIALS']
      Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: StringIO.new(ENV['GOOGLE_APPLICATION_CREDENTIALS']),
        scope: ['https://www.googleapis.com/auth/youtube.upload']
      )
    else
      client_id = Google::Auth::ClientId.from_hash(
        'web' => {
          'client_id' => ENV['GOOGLE_CLIENT_ID'],
          'client_secret' => ENV['GOOGLE_CLIENT_SECRET']
        }
      )
      
      token_store = Google::Auth::Stores::FileTokenStore.new(
        file: Rails.root.join('config', 'google_token.yaml')
      )
      
      authorizer = Google::Auth::UserAuthorizer.new(client_id, ['https://www.googleapis.com/auth/youtube.upload'], token_store)
      credentials = authorizer.get_credentials('default')
      
      if credentials.nil?
        raise "No YouTube credentials found. Please run the authorization flow."
      end
      
      credentials
    end
  end

  def generate_title(video)
    travel_tip = video.travel_tip
    "#{travel_tip.city} Marathon Guide: Hidden Gems & Money-Saving Tips! #Shorts"
  end

  def generate_description(video)
    travel_tip = video.travel_tip
    <<~DESCRIPTION
      🏃‍♂️ #{travel_tip.marathon} Travel Guide

      Discover the best places to stay, eat, and explore in #{travel_tip.city}!
      
      #{travel_tip.case_study.split("\n").first}
      
      Follow for more marathon travel tips! 🌎✈️
      
      Source: #{travel_tip.source_url}
      
      #MarathonTravel ##{travel_tip.city.gsub(/\s+/, '')} #TravelTips #Marathon #Travel ##{travel_tip.marathon.gsub(/\s+/, '')}
      
      *For informational purposes only. Please consult a travel advisor.
    DESCRIPTION
  end

  def generate_tags(video)
    travel_tip = video.travel_tip
    [
      'Marathon Travel',
      'Travel Tips',
      'Marathon Training',
      travel_tip.city,
      travel_tip.marathon,
      'Travel Guide',
      'Running',
      'Tourism',
      'Adventure Travel',
      'Travel Vlog',
      'Shorts'
    ]
  end
end 