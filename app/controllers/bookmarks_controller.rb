# frozen_string_literal: true

class BookmarksController < ApplicationController
  def index
    @user = current_user
    @library = @user.saved_episodes
  end
  def create
    bookmark = Bookmark.new
    bookmark.user = current_user
    bookmark.episode = Episode.find(params[:episode_id])
    if bookmark.save! && params[:donation_id].present?
      donation = Donation.find(params[:donation_id])
      Notification.create!(user: donation.user, bookmark: bookmark)
    end
  end

  def destroy
    @bookmark = Bookmark.where(user: current_user).find_by(episode: params[:episode_id])
    @bookmark.notifications.destroy_all
    @bookmark.destroy
  end
end
