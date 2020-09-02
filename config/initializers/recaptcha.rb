Recaptcha.configure do |config|
  config.site_key = Rails.application.credentials.dig(:recaptcha, :site_key)
  config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
  # Use this for proxy
  # config.proxy = 'http://someproxy.com.au:8080'
end
