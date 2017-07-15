source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'slim-rails'
gem 'bootstrap-sass'

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'faker'
end

group :development, :test do
  gem 'pry'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  gem 'annotate'
  gem 'rubocop', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
end
