class DonationsController < ApplicationController
  def index
    @user = current_user
    @donations = @user.donations
  end

  def new
    @donation = Donation.new
    @episode = Episode.find_by(name: params['hidden-episode'])
  end

  def create
    @donation = Donation.new(donation_params)
    @episode = Episode.find(params[:donation][:episode])
    @donation.episode = @episode
    @donation.user = current_user
    raise
    if @donation.save
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
