source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'devise'

gem 'shopify_app'
gem 'httparty', '~> 0.13.7'
gem 'griddler'
gem 'griddler-sendgrid'
gem 'bootstrap', '~> 4.1.3'
gem 'json', '~> 1.8', '>= 1.8.3'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'normalize-rails'
gem "stroke-seven-rails"
gem 'flag-icons-rails'
gem 'popper_js', '~> 1.14.3'
gem 'jquery-matchheight-rails'
gem 'momentjs-rails'
gem "autoprefixer-rails"
gem 'mini_racer'
# gem 'rails-ujs'
# gem for styling
gem 'font-awesome-rails'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'toastr-rails'


gem 'shopify_api'
gem "aftership", "~> 4.3.1"
gem 'httparty', '~> 0.13.7'
gem 'puma_worker_killer'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  
  
  # gems for debugging
  gem 'pry'
  gem "awesome_print", require: "ap"
  gem 'pry-byebug'

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
