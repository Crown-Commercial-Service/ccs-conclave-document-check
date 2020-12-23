source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# for S3 storage of files
gem 'carrierwave-aws', '~> 1.3.0'

# Helps you manage translations
gem 'i18n-tasks', '~> 0.9.31'

# for clamav
gem 'ratonvirus', '>= 0.1.1'
gem 'ratonvirus-clamby', '>= 0.1.0'

# Sidekiq - using an older version that works with redis v3.2.6
gem 'sidekiq', '~> 5.0.0.rc1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # Rspec
  gem 'rspec-rails', '~> 4.0.1'
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'shoulda-matchers', '~> 4.4.1'
  gem 'faker'
  gem 'database_cleaner'
  gem "webmock"
  gem 'rspec-sidekiq'
end
