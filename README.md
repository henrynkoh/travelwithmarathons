# Marathon Wanderer

An automated YouTube Shorts channel that combines marathon participation with travel experiences, providing comprehensive guides for 12 global marathon cities.

## Features

- Automated travel data collection from marathon websites and travel platforms
- AI-driven itinerary and case study generation
- Automated video production with text-to-speech and stock footage
- YouTube Shorts upload automation
- Web dashboard for monitoring and management

## Tech Stack

- Ruby 3.2.2
- Rails 8.0.2
- SQLite (database)
- Sidekiq (background jobs)
- Redis (job queue)
- FFMPEG (video processing)
- AWS S3 (optional media storage)
- Google YouTube API (video upload)

## Prerequisites

- Ruby 3.2.2
- Rails 8.0.2
- Redis
- FFMPEG
- Python (for video processing)
- Node.js & Yarn

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/marathon_wanderer.git
   cd marathon_wanderer
   ```

2. Install dependencies:
   ```bash
   bundle install
   pip install moviepy gTTS requests
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys and credentials
   ```

4. Set up the database:
   ```bash
   rails db:create db:migrate
   ```

5. Start the services:
   ```bash
   # In separate terminals:
   rails server
   bundle exec sidekiq
   ```

6. Visit http://localhost:3000 to access the dashboard

## Configuration

### Required API Keys

- NewsAPI: For sentiment analysis
- Pexels API: For stock footage
- Google API: For YouTube upload
- AWS (optional): For S3 storage

### YouTube Setup

1. Create a Google Cloud Project
2. Enable the YouTube Data API v3
3. Create OAuth 2.0 credentials
4. Set up a service account for automated uploads

## Usage

### Dashboard

The dashboard provides:
- Overview statistics
- Video status monitoring
- Manual controls for video approval
- Travel tip management

### Automated Tasks

- Data crawling: Runs every Tuesday, Friday, and Sunday at 6 AM
- Video production: Triggered after travel tip analysis
- YouTube upload: Automatic after video production

### Manual Controls

- Start new data crawl
- Approve pending videos
- Retry failed videos
- View uploaded videos on YouTube

## Development

### Adding New Cities

Edit `app/services/travel_crawler.rb`:
```ruby
MARATHON_CITIES = {
  'City' => 'Marathon Name',
  # Add new cities here
}
```

### Customizing Video Templates

Edit `app/services/video_producer.rb` to modify:
- Video format
- Text overlays
- Audio settings
- Transition effects

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Marathon websites for race information
- TripAdvisor for travel data
- Pexels for stock footage
- Google Cloud Platform for YouTube integration
