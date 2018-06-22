# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "info@mendio.co"
  layout "mailer"
end
