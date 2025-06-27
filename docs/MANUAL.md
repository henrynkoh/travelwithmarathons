# Marathon Wanderer - User Manual

## Table of Contents
1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Dashboard Guide](#dashboard-guide)
4. [Content Management](#content-management)
5. [Troubleshooting](#troubleshooting)
6. [Best Practices](#best-practices)

## Introduction
Marathon Wanderer is an automated platform that creates and manages YouTube Shorts content focusing on marathon tourism. This manual provides detailed instructions for operating and maintaining the platform.

## Getting Started

### System Requirements
- Operating System: macOS, Linux, or Windows
- Ruby 3.2.2
- Rails 8.0.2
- Redis Server
- FFMPEG
- Python 3.x
- Node.js & Yarn

### Initial Setup
1. System Installation:
   ```bash
   # Install Ruby
   rbenv install 3.2.2
   rbenv global 3.2.2

   # Install Rails
   gem install rails -v 8.0.2

   # Install Redis
   brew install redis # (macOS)
   sudo apt-get install redis-server # (Ubuntu)

   # Install FFMPEG
   brew install ffmpeg # (macOS)
   sudo apt-get install ffmpeg # (Ubuntu)
   ```

2. Application Setup:
   ```bash
   # Clone repository
   git clone https://github.com/yourusername/marathon_wanderer.git
   cd marathon_wanderer

   # Install dependencies
   bundle install
   pip install moviepy gTTS requests

   # Setup database
   rails db:create db:migrate
   ```

3. Configuration:
   - Copy `.env.example` to `.env`
   - Add required API keys:
     - NewsAPI
     - Pexels API
     - Google API credentials
     - AWS S3 (optional)

## Dashboard Guide

### Main Dashboard Features
1. Statistics Overview
   - Total Travel Tips
   - Total Videos
   - Pending/Uploaded/Failed counts

2. Video Management
   - View all videos
   - Check status
   - Approve pending videos
   - Retry failed videos

3. Travel Tips Section
   - View all marathon cities
   - Check sentiment analysis
   - Access source links

### Common Tasks
1. Starting a New Crawl:
   - Click "Start New Crawl" button
   - Monitor progress in Recent Videos

2. Video Approval Process:
   - Review pending videos
   - Click "Approve" to start production
   - Monitor status changes

3. Handling Failures:
   - Check error logs
   - Click "Retry" for failed videos
   - Monitor retry progress

## Content Management

### Travel Tips
1. Adding New Cities:
   - Edit `app/services/travel_crawler.rb`
   - Add to `MARATHON_CITIES` hash
   - Run new crawl

2. Customizing Content:
   - Edit templates in `app/services/travel_analyzer.rb`
   - Modify itinerary formats
   - Update case study templates

### Video Production
1. Video Settings:
   - Resolution: 1080x1920 (vertical)
   - Length: 45 seconds
   - Format: MP4

2. Customization Options:
   - Edit overlay text
   - Modify transitions
   - Change voice settings

## Troubleshooting

### Common Issues
1. Crawling Failures:
   - Check API limits
   - Verify source URLs
   - Review error logs

2. Video Production Issues:
   - Check FFMPEG installation
   - Verify storage space
   - Check file permissions

3. Upload Failures:
   - Verify YouTube credentials
   - Check quota limits
   - Review network connectivity

### Error Recovery
1. Database Reset:
   ```bash
   rails db:reset
   rails db:migrate
   ```

2. Cache Clear:
   ```bash
   rails tmp:cache:clear
   ```

3. Job Queue Reset:
   ```bash
   redis-cli FLUSHALL
   ```

## Best Practices

### Content Quality
1. Marathon Coverage:
   - Update city information regularly
   - Verify marathon dates
   - Check travel restrictions

2. Video Optimization:
   - Use engaging thumbnails
   - Optimize titles for SEO
   - Include relevant hashtags

### System Maintenance
1. Regular Tasks:
   - Monitor disk space
   - Check API quotas
   - Update dependencies

2. Backup Procedures:
   - Database backup
   - Configuration backup
   - Content backup

### Security
1. API Key Management:
   - Rotate keys regularly
   - Monitor usage
   - Secure storage

2. Access Control:
   - Regular password updates
   - IP restrictions
   - Activity monitoring 