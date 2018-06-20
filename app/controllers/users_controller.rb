class UsersController < ApplicationController
  before_action :set_user
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
