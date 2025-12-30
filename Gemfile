source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Rails core
gem 'rails', '~> 7.1.0'
gem 'pg'
gem 'puma', '~> 6.0'

# Rails 7: prefer css/js bundling instead of sass-rails/webpacker
gem 'sassc-rails'
gem 'jsbundling-rails'
gem 'cssbundling-rails'
gem 'turbo-rails'
gem 'jbuilder', '~> 2.7'
gem 'devise'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'simple_form'
gem 'faker'
gem 'cicero'
gem 'autoprefixer-rails', '10.2.5'
gem 'font-awesome-sass', '~> 5.6.1'
gem 'geocoder'
gem 'cloudinary', '~> 1.16.0'
gem 'image_processing', '~> 1.2'
gem 'dotenv-rails', groups: [:development, :test]

group :development, :test do
	gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
	gem 'web-console', '>= 4.1.0'
	gem 'rack-mini-profiler', '~> 2.0'
	gem 'listen', '~> 3.3'
	# gem 'spring'
end

group :test do
	gem 'capybara', '>= 3.26'
	gem 'selenium-webdriver'
	gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Nokogiri (require modern version for newer Ruby)
gem 'nokogiri', '>= 1.15'
