require File.join(Rails.root, 'app/workers/sessions_scraper')

namespace :sidekiq do
  task :sessions do
    SessionsScraper.perform_async
  end
end

