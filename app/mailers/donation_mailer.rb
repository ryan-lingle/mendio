# frozen_string_literal: true

class DonationMailer < ApplicationMailer
  def creation_confirmation(donation, user)
    @donation = donation
    @user = user

    mail(
      to:       @donation.user.email,
      subject:  "You've received #{@donation.amount} from a new donation!"
    )
  end
end
