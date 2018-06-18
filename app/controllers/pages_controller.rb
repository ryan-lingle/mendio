class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if user_signed_in?
      @user = current_user
      @feed = @user.feed
    end
  end
end
