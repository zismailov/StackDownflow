source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "rails", "~> 5.1.2"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

gem "bootstrap-sass"
gem "coffee-rails", "~> 4.2"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "simple_form"
gem "slim-rails"

gem "active_model_serializers"
gem "carrierwave"
gem "devise"
gem "handlebars_assets"
gem "remotipart"

gem "cocoon"
gem "private_pub"
gem "responders"
gem "thin"

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "faker"
  gem "poltergeist"
  gem "shoulda-matchers"
end

group :development, :test do
  gem "factory_girl_rails"
  gem "launchy"
  gem "pry"
  gem "rspec-rails"
end

group :development do
  gem "annotate"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop", require: false
  gem "spring"
  gem "spring-commands-rspec"
end
