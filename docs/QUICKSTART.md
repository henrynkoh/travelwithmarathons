# Marathon Wanderer - Quick Start Guide

Get your automated marathon travel content creation platform running in minutes!

## 🚀 5-Minute Setup

1. **Clone & Install**
   ```bash
   git clone https://github.com/yourusername/marathon_wanderer.git
   cd marathon_wanderer
   bundle install
   ```

2. **Configure Environment**
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. **Setup Database**
   ```bash
   rails db:setup
   ```

4. **Start Services**
   ```bash
   redis-server &
   bundle exec sidekiq &
   rails server
   ```

5. **Access Dashboard**
   - Open http://localhost:3000
   - Login with default credentials:
     - Username: admin
     - Password: marathonwanderer2024

## 🎯 First Content Creation

1. **Start Crawling**
   - Click "Start New Crawl" on dashboard
   - Wait ~5 minutes for initial results

2. **Review Content**
   - Check "Travel Tips" section
   - Approve or edit generated content

3. **Create Video**
   - Select approved content
   - Click "Generate Video"
   - Preview in "Videos" section

4. **Publish**
   - Review final video
   - Click "Upload to YouTube"
   - Monitor in "Published" section

## 📱 Quick Social Media Setup

1. **Connect Accounts**
   - YouTube: Click "Connect" in Settings
   - Other platforms: Add API keys in .env

2. **Auto-Posting**
   - Enable in Settings > Automation
   - Set posting schedule
   - Choose platforms

## 🔍 Quick Monitoring

1. **Dashboard Metrics**
   - Content count
   - Success rate
   - Engagement stats

2. **System Health**
   - Service status
   - API quotas
   - Storage usage

## 🆘 Quick Troubleshooting

1. **Services Down?**
   ```bash
   # Restart all services
   ./bin/dev restart
   ```

2. **Content Issues?**
   - Check API keys in .env
   - Verify internet connection
   - Check error logs

3. **Need Help?**
   - Documentation: /docs
   - Issues: GitHub Issues
   - Support: support@marathonwanderer.com

## 📈 Next Steps

1. **Customize Content**
   - Edit templates in app/services
   - Modify video styles
   - Add new marathon cities

2. **Optimize**
   - Review analytics
   - Adjust posting schedule
   - Fine-tune content

3. **Scale**
   - Add more cities
   - Increase frequency
   - Expand platforms 