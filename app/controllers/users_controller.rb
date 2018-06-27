# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_user, except: [ :index, :dashboard, :new_podcast, :create_account, :account_info]
  def index
    PgSearch::Multisearch.rebuild(User)
    PgSearch::Multisearch.rebuild(Podcast)
    @results = PgSearch.multisearch(params[:query])
  end

  def show
    @donations = @user.donations
    @following = @user.following
    @followers = @user.followed_by
    @episodes = @user.saved_episodes
  end

  def toggle_follow
    if current_user.following?(@user)
      current_user.unfollow(@user)
    else
      current_user.follow(@user)
      Notification.create!(user: @user, follower: current_user)
    end
  end

  def dashboard
    @user = current_user
    @podcasts = @user.podcasts
  end

  def new_podcast
  end

  def create_account
    @user = current_user
    account = Stripe::Account.create(
      type: 'custom',
      country: 'US',
      email: @user.email
    )
    account.legal_entity.address.city = params[:city]
    account.legal_entity.address.line1 = params[:line1]
    account.legal_entity.address.line2 = params[:line2] if params[:line2].present?
    account.legal_entity.address.postal_code = params[:postal_code]
    account.legal_entity.address.state = params[:state]
    account.legal_entity.dob.day = params[:day]
    account.legal_entity.dob.month = params[:month]
    account.legal_entity.dob.year = params[:year]
    account.legal_entity.first_name = @user.first_name
    account.legal_entity.last_name = @user.last_name
    account.legal_entity.ssn_last_4 = params[:ssn]
    account.legal_entity.type = 'individual'
    account.tos_acceptance.date = Time.now.to_time.to_i
    account.tos_acceptance.ip = request.remote_ip
    account.external_accounts.create(external_account: params[:stripeToken])
    account.save
    @user.account_id = account.id
    @user.account = true
    @user.save!
    redirect_to dashboard_path
  end

  def account_info

  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
