class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_user, except: :index
  def index
    if params[:query].present?
      PgSearch::Multisearch.rebuild(User)
      PgSearch::Multisearch.rebuild(Podcast)
      @results = PgSearch.multisearch(params[:query])
    else
      @results = Podcast.all
    end
  end

  def show
    @donations = @user.donations
    @following = @user.following
    @followers = @user.followed_by
  end

  def toggle_follow
    if current_user.following?(@user)
      current_user.unfollow(@user)
    else
      current_user.follow(@user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
