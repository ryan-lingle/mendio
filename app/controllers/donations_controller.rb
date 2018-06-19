class DonationsController < ApplicationController
  def index
    @user = current_user
    @donations = @user.donations
  end

  def new
    @donation = Donation.new
    @episode = Episode.find_by(name: params['episode'])
    respond_to do |format|
      format.html { redirect_to select_episode_path }
      format.js  # <-- will render `app/views/reviews/create.js.erb`
    end
  end

  def create
    @donation = Donation.new(donation_params)
    @episode = Episode.find(params[:donation][:episode])
    @donation.episode = @episode
    @donation.user = current_user
    if @donation.save
      DonationMailer.creation_confirmation(@donation).deliver_now
      redirect_to root_path
    else
      render 'new'
    end
  end

  private
  def donation_params
    params.require(:donation).permit(:amount)
  end
end
