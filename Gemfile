source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.0.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  gem 'bullet', '~> 6.1.4' # for N+1 queries
  gem 'letter_opener', '~> 1.7.0'
  # gem 'meta_request', '~> 0.7.2' # browser extension for rails metrics
  gem 'spring-watcher-listen', '~> 2.0.1'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  # gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Used Gems for Ease
gem 'awesome_print', '~> 1.9.2', require: 'ap' # for rails console
gem 'breadcrumbs_on_rails', '~> 4.1.0'
gem 'cancancan', '~> 3.2.1'
gem 'devise', '~> 4.8.0'
gem 'devise_invitable', '~> 2.0.5'
gem 'actionmailer', '~> 6.1.3.1'
gem 'actionpack', '~> 6.1.3.1'
gem 'railties', '~> 6.1.3.1'
gem 'figaro', '~> 1.2.0'
gem 'friendly_id', '~> 5.4.2'
gem 'interactor', '~> 3.1.2'
gem 'money-rails', '~> 1.14.0'
gem 'omniauth-facebook', '~> 8.0.0'
gem 'omniauth-google-oauth2', '~> 1.0.0'
gem 'omniauth-linkedin-oauth2', '~> 1.0.0'
gem 'omniauth-twitter', '~> 1.4.0'
gem 'paperclip', '~> 3.5.0'
gem 'rolify', '~> 6.0.0'
gem 'rubocop', '~> 1.13.0', require: false
gem 'stripe', '~> 5.32.1'
gem 'ultrahook', '~> 1.0.1'