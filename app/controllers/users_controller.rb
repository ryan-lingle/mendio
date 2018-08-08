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
    ip = request.remote_ip
    @user.create_account(params, ip)
    redirect_to dashboard_path
  end

  def account_info

  end

  private

    def set_user
      @user = User.find(params[:id])
    end
end
