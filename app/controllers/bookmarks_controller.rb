class BookmarksController < ApplicationController
  def index
    @user = current_user
    @library = @user.saved_donations
  end
  def create
    bookmark = Bookmark.new
    bookmark.user = current_user
    bookmark.donation = Donation.find(params[:donation_id])
    bookmark.save
  end
end
