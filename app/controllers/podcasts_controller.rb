# frozen_string_literal: true

class PodcastsController < ApplicationController
  def find
    if params[:query].present?
      @result = Podcast.find_by_name(params[:query])
      respond_to do |format|
        format.html { render "episodes/selection" }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    end
  end

  def show
    @podcast = Podcast.find(params[:id])
    @episodes = @podcast.episodes
  end

  def create
    if Podcast.rss_builder(current_user, params[:rss])
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end
end
