class ShowsController < ApplicationController
  before_action :require_user

  def create
    @user = current_user.shows.new(show_params)
    if @user.save
      render json: @user.shows.last, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
end

 private
   def show_params
     params.permit(:title, :genre, :show_image, :synopsis, :seasons, :date, :gn_id)
   end

end