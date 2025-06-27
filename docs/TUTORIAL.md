# Marathon Wanderer - Tutorial

This tutorial will walk you through common tasks and workflows in Marathon Wanderer, with practical examples.

## 1. Creating Your First Travel Tip

### Example: Adding Boston Marathon Tips

1. **Access the Dashboard**
   ```ruby
   # app/controllers/dashboard_controller.rb
   def create_travel_tip
     @travel_tip = TravelTip.new(travel_tip_params)
     @travel_tip.city = "Boston"
     @travel_tip.marathon_name = "Boston Marathon"
     @travel_tip.save
   end
   ```

2. **Add Content**
   ```ruby
   # Example travel tip content
   {
     title: "Best Pre-Race Pasta in Boston",
     content: "Located in North End, Giacomo's offers...",
     category: "food",
     source_url: "https://example.com/boston-restaurants"
   }
   ```

3. **Preview and Publish**
   ```ruby
   # app/services/travel_analyzer.rb
   def analyze_tip
     sentiment = analyze_sentiment(@travel_tip.content)
     keywords = extract_keywords(@travel_tip.content)
     generate_summary(sentiment, keywords)
   end
   ```

## 2. Creating a Video

### Example: Tokyo Marathon Video

1. **Prepare Assets**
   ```ruby
   # app/services/video_producer.rb
   def prepare_video
     # Stock footage selection
     clips = select_clips("Tokyo", ["cityscape", "runners", "temples"])
     
     # Text overlay
     text = generate_overlay_text(@travel_tip.title, @travel_tip.content)
     
     # Background music
     music = select_background_music("energetic", duration: 45)
   end
   ```

2. **Edit Video**
   ```python
   # Example FFMPEG command
   ffmpeg -i input.mp4 \
         -vf "scale=1080:1920,drawtext=text='Tokyo Marathon Guide'" \
         -t 45 \
         output.mp4
   ```

3. **Add Voiceover**
   ```python
   from gtts import gTTS
   
   text = "Welcome to our Tokyo Marathon guide..."
   tts = gTTS(text=text, lang='en')
   tts.save("voiceover.mp3")
   ```

## 3. Scheduling Content

### Example: Weekly Content Plan

1. **Configure Sidekiq**
   ```yaml
   # config/sidekiq.yml
   :schedule:
     crawl_travel_tips:
       cron: '0 6 * * 2,5,0'  # 6 AM on Tue, Fri, Sun
       class: CrawlTravelTipsJob
   ```

2. **Set Up Job**
   ```ruby
   # app/jobs/crawl_travel_tips_job.rb
   def perform
     cities = ["Boston", "Tokyo", "London", "Berlin"]
     cities.each do |city|
       TravelCrawler.new(city).crawl
     end
   end
   ```

## 4. Customizing Templates

### Example: Video Template

1. **Edit Video Template**
   ```ruby
   # app/services/video_producer.rb
   class VideoTemplate
     INTRO_DURATION = 3
     MAIN_CONTENT_DURATION = 37
     OUTRO_DURATION = 5
     
     def generate_template
       {
         intro: {
           text: "Marathon Wanderer Presents",
           animation: "fade_in",
           duration: INTRO_DURATION
         },
         main_content: {
           sections: ["city_view", "tips", "maps"],
           transitions: ["dissolve", "slide_left"],
           duration: MAIN_CONTENT_DURATION
         },
         outro: {
           call_to_action: "Follow for more marathon tips!",
           duration: OUTRO_DURATION
         }
       }
     end
   end
   ```

2. **Customize Styles**
   ```css
   /* app/assets/stylesheets/video.css */
   .video-overlay {
     font-family: 'Montserrat', sans-serif;
     font-size: 32px;
     color: #ffffff;
     text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
   }
   ```

## 5. Analytics Integration

### Example: Track Video Performance

1. **Set Up Tracking**
   ```ruby
   # app/services/analytics_tracker.rb
   def track_video_performance(video)
     metrics = {
       views: fetch_youtube_views(video.youtube_id),
       engagement: calculate_engagement_rate(video),
       shares: fetch_social_shares(video.url)
     }
     
     update_analytics_dashboard(metrics)
   end
   ```

2. **Generate Reports**
   ```ruby
   # app/services/report_generator.rb
   def generate_weekly_report
     Report.new.tap do |report|
       report.total_views = Video.sum(:view_count)
       report.top_performing = Video.order(engagement_rate: :desc).first(5)
       report.growth_rate = calculate_growth_rate
     end
   end
   ```

## 6. Error Handling

### Example: Video Processing Errors

1. **Implement Error Handling**
   ```ruby
   # app/services/video_producer.rb
   def process_video
     begin
       generate_video
     rescue FFMPEGError => e
       handle_ffmpeg_error(e)
     rescue StorageError => e
       handle_storage_error(e)
     ensure
       cleanup_temporary_files
     end
   end
   ```

2. **Retry Logic**
   ```ruby
   # app/jobs/produce_video_job.rb
   retry_on FFMPEGError, wait: 5.minutes, attempts: 3
   retry_on StorageError, wait: 10.minutes, attempts: 2
   
   def perform(video_id)
     video = Video.find(video_id)
     VideoProducer.new(video).process
   end
   ```

## 7. API Integration

### Example: YouTube Upload

1. **Configure API**
   ```ruby
   # config/initializers/youtube.rb
   YOUTUBE_CLIENT = Google::Apis::YoutubeV3::YouTubeService.new
   YOUTUBE_CLIENT.authorization = Google::Auth::ServiceAccountCredentials.new(
     json_key_io: File.open(Rails.root.join('config', 'youtube_credentials.json'))
   )
   ```

2. **Upload Video**
   ```ruby
   # app/services/youtube_uploader.rb
   def upload_video
     metadata = {
       snippet: {
         title: @video.title,
         description: generate_description,
         tags: generate_tags
       },
       status: {
         privacyStatus: "public",
         selfDeclaredMadeForKids: false
       }
     }
     
     YOUTUBE_CLIENT.insert_video("snippet,status", metadata, upload_source: @video.file_path)
   end
   ```

## 8. Testing

### Example: Video Generation Tests

1. **Unit Tests**
   ```ruby
   # spec/services/video_producer_spec.rb
   RSpec.describe VideoProducer do
     let(:travel_tip) { create(:travel_tip) }
     let(:producer) { VideoProducer.new(travel_tip) }
     
     it "generates video with correct duration" do
       video = producer.generate_video
       expect(video.duration).to eq(45.seconds)
     end
     
     it "includes required overlays" do
       video = producer.generate_video
       expect(video.has_text_overlay?).to be true
       expect(video.has_logo?).to be true
     end
   end
   ```

2. **Integration Tests**
   ```ruby
   # spec/integration/video_processing_spec.rb
   RSpec.describe "Video Processing", type: :integration do
     it "processes video end-to-end" do
       travel_tip = create(:travel_tip)
       
       expect {
         ProduceVideoJob.perform_now(travel_tip.id)
       }.to change { Video.count }.by(1)
       
       video = Video.last
       expect(video.status).to eq("completed")
       expect(video.youtube_url).to be_present
     end
   end
   ```

## 9. Deployment

### Example: Docker Deployment

1. **Dockerfile Configuration**
   ```dockerfile
   # Dockerfile
   FROM ruby:3.2.2
   
   # Install dependencies
   RUN apt-get update && apt-get install -y \
       ffmpeg \
       python3-pip \
       nodejs \
       npm
   
   # Install Python packages
   RUN pip3 install moviepy gTTS
   
   # Set up app
   WORKDIR /app
   COPY . /app/
   RUN bundle install
   
   # Start services
   CMD ["./bin/dev"]
   ```

2. **Docker Compose**
   ```yaml
   # docker-compose.yml
   version: '3'
   services:
     web:
       build: .
       ports:
         - "3000:3000"
       depends_on:
         - redis
         - sidekiq
     
     redis:
       image: redis:latest
     
     sidekiq:
       build: .
       command: bundle exec sidekiq
       depends_on:
         - redis
   ```

## 10. Monitoring

### Example: System Health Checks

1. **Service Health**
   ```ruby
   # app/services/health_checker.rb
   def check_system_health
     {
       redis: check_redis_connection,
       sidekiq: check_sidekiq_status,
       storage: check_storage_space,
       api_quotas: check_api_quotas
     }
   end
   ```

2. **Alert System**
   ```ruby
   # app/services/alert_service.rb
   def send_alert(issue)
     return unless critical?(issue)
     
     NotificationService.notify_admin(
       title: "System Alert",
       message: issue.description,
       severity: issue.severity
     )
   end
   ``` 