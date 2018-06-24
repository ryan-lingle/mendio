# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.reverse
    @notifications.each { |n| n.make_seen }
  end
end
