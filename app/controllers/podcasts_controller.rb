class PodcastsController < ApplicationController
  def find
    if params[:query].present?
      @result = Podcast.find_by_name(params[:query])
      respond_to do |format|
        format.html { render 'episodes/selection' }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      raise
    end
  end
end
