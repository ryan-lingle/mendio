# frozen_string_literal: true

class EpisodesController < ApplicationController
  def find
    if params[:query].present?
      @results = Episode.limit(10).where(podcast: params[:podcast_id]).search(params[:query])
      respond_to do |format|
        format.html { redirect_to podcast_path(params[:podcast_id]) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      @results = Episode.all
    end
  end

  def index
    respond_to do |format|
      format.html { redirect_to podcast_path(params[:podcast_id]) }
      format.js
    end
  end

  def show
    @episode = Episode.find(params[:id])
    @donations = @episode.donations
  end
end
