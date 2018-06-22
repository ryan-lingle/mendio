# frozen_string_literal: true

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    if user_signed_in?
      @user = current_user
      @following
      @feed = @user.feed
    end
    render layout: "onboarding"
  end
end
