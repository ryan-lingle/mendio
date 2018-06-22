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
    bookmark.save
    Notification.create!(user: current_user, bookmark: bookmark)
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
  end
end
