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
    @donation = Donation.new(donation_params)
    @episode = Episode.find(params[:donation][:episode])
    @influencer = current_user.has_seen?(@episode)
    if @influencer
      @donation.influencer = @influencer
    end
    @donation.episode = @episode
    @donation.user = current_user
    if @donation.save!
      Notification.create!(user: @influencer, donation: @donation)
      flash[:notice] = "Thank you for donating!"
      # DonationMailer.creation_confirmation(@donation, @user).deliver_now
      redirect_to root_path
    else
      render "new"
    end
  end

  private
    def donation_params
      params.require(:donation).permit(:amount)
    end
end
