# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.x'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rails-erd' # !
  gem 'solargraph' # !
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'active_storage_validations'
gem 'bootstrap', '~> 4.5.2'
gem 'chartkick'
gem 'cocoon'
gem 'devise'
gem 'exception_notification', group: :production
gem 'faker'
gem 'font-awesome-sass', '~> 5.13.0'
gem 'friendly_id', '~> 5.4.0'
gem 'google-cloud-storage', '~> 1.11', require: false
gem 'groupdate'
gem 'haml-rails', '~> 2.0'
gem 'image_processing'
gem 'jquery-rails'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-google-oauth2'
gem 'omniauth-vkontakte'
gem 'pagy'
gem 'public_activity'
gem 'pundit'
gem 'ranked-model'
gem 'ransack'
gem 'recaptcha'
gem 'rolify'
gem 'simple_form'
gem 'wicked'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary', group: :development
gem 'wkhtmltopdf-heroku', group: :production
