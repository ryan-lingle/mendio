# frozen_string_literal: true

class EpisodesController < ApplicationController
  def find
    if params[:query].present?
      @results = Episode.where(podcast: params[:podcast_id]).search(params[:query])
      respond_to do |format|
        format.html { redirect_to new_donation_path }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      @results = Episode.all
    end
  end
end
