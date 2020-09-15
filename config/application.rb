require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Rubygems
  class Application < Rails::Application
    config.load_defaults 6.0

    config.i18n.fallbacks = true
    config.i18n.default_locale = :en
    I18n.available_locales = %i[en ru]

    config.to_prepare do
      ActionText::ContentHelper.allowed_tags << 'iframe'

      ActionText::ContentHelper.allowed_attributes.add 'style'
      ActionText::ContentHelper.allowed_attributes.add 'controls'

      ActionText::ContentHelper.allowed_tags.add 'video'
      ActionText::ContentHelper.allowed_tags.add 'audio'
      ActionText::ContentHelper.allowed_tags.add 'source'
    end
  end
end
