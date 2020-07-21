class ApplicationMailer < ActionMailer::Base
  default from: 'support@ext-rubygems.herokuapp.com'
  layout 'mailer'
end
