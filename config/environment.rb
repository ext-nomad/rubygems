# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# SMTP settings for SendInBlue Mailer
ActionMailer::Base.smtp_settings = {
  port: Rails.application.credentials.dig(:send_in_blue, :port),
  address: Rails.application.credentials.dig(:send_in_blue, :address),
  user_name: Rails.application.credentials.dig(:send_in_blue, :login),
  password: Rails.application.credentials.dig(:send_in_blue, :password),
  domain: 'ext-rubygems.herokuapp.com',
  authentication: :plain,
  enable_starttls_auto: true
}

# ActionMailer::Base.smtp_settings = {
#   port: ENV['SIB_SMTP_PORT'],
#   address: ENV['SIB_SMTP_ADRESS'],
#   user_name: ENV['SIB_SMTP_LOGIN'],
#   password: ENV['SIB_SMTP_PASSWORD'],
#   domain: 'ext-rubygems.herokuapp.com',
#   authentication: :plain,
#   enable_starttls_auto: true
# }
