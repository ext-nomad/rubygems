require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Rubygems
  class Application < Rails::Application
    config.load_defaults 6.0

    # # For rails-erd gem
    # if Rails.env.development?
    #   def eager_load!
    #     Zeitwerk::Loader.eager_load_all
    #   end
    # end
    config.after_initialize do
      ActionText::ContentHelper.allowed_attributes.add 'style'
      ActionText::ContentHelper.allowed_attributes.add 'controls'

      ActionText::ContentHelper.allowed_tags.add 'video'
      ActionText::ContentHelper.allowed_tags.add 'audio'
      ActionText::ContentHelper.allowed_tags.add 'source'
    end
    # i18n
    # config.i18n.fallbacks = true
  end
end
