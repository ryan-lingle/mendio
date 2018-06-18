class PodcastsController < ApplicationController
  def find
    if params[:query].present?
      @result = Podcast.search(params[:query])[0]
      respond_to do |format|
        format.html { redirect_to new_donation_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      raise
    end
  end
end