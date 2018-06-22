# frozen_string_literal: true

class ViewsController < ApplicationController
  def create
    @donation = Donation.find(params[:id])
    unless @donation.user == current_user
      view = View.new(user: current_user, donation: @donation)
      if view.save
        head :no_content
      else
        render json: { error: view.errors.full_messages }
      end
    end
  end
end
