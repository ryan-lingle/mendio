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
    begin
      @error = nil
      if Podcast.rss_builder(current_user, params[:rss])
        redirect_to dashboard_path
      else
        @error = "It seems that your account's email does not correspond to the email provided in the RSS Feed."
        render 'new'
      end
    rescue => e
      @error = 'Not a Valid RSS Feed. Ensure that you are submitting a RSS Feed that has been validated by itunes.'
      render 'new'
    end
  end
end
