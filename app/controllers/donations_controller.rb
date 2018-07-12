# frozen_string_literal: true

class DonationsController < ApplicationController
  def index
    @user = current_user
    @donations = @user.donations
  end

  def new
    @donation = Donation.new
    @episode = Episode.find_by(name: params["episode"])
    respond_to do |format|
      format.html { redirect_to select_episode_path }
      format.js  # <-- will render `app/views/reviews/create.js.erb`
    end
  end

  def create
    @user = current_user
    @amount = donation_params[:amount]
    @episode = Episode.find(params[:donation][:episode])
    @podcast = @episode.podcast
    if BlockIo.withdraw_from_labels :amounts => "#{(@amount.to_f * 0.8).round(10)}", from_labels: @user.label, to_label: @podcast.label, nonce: SecureRandom.hex
      @donation = Donation.new(donation_params)
      @influencer = current_user.has_seen?(@episode)
      if @influencer
        @donation.influencer = @influencer
        BlockIo.withdraw_from_labels amounts: "#{(@amount.to_f * 0.2).round(10)}", from_labels: @user.label, to_label: @influencer.label, nonce: SecureRandom.hex
      end
      @donation.episode = @episode
      @donation.user = current_user
      if @donation.save!
        Notification.create!(user: @influencer, donation: @donation) if @influencer
        flash[:notice] = "Thank you for donating!"
        # DonationMailer.creation_confirmation(@donation, @user).deliver_now
        redirect_to root_path
      else
        render "new"
      end
    end
  end

  private
    def donation_params
      params.require(:donation).permit(:amount)
    end
end
