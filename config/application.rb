require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Gymshare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_mailer.default_url_options = { host: "http://127.0.0.1:3000" }
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # config.asset_host = 'https://3000-pinfada-gymproject-g2bft8ubywy.ws-eu74.gitpod.io/'
    config.to_prepare do
      # Set Devise Mailer layout
      Devise::Mailer.layout 'mailer'
    end
  end
end
