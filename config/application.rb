require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StackDownflow
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # config.load_defaults 5.1

    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    config.sass.preferred_syntax = :sass

    config.generators do |g|
      g.template_engine :slim
      g.test_framework :rspec,
                       view_specs:    false,
                       request_specs: false,
                       routing_specs: false,
                       helper_specs:  false
    end

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
