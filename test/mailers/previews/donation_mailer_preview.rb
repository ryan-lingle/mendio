# Preview all emails at http://localhost:3000/rails/mailers/donation_mailer
class DonationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/donation_mailer/notification
  def notification
    DonationMailer.notification
  end

end
