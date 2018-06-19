class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @donations = @user.donations
    @following = @user.following
    @followers = @user.followed_by
  end
end
