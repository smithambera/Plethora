class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :require_user

  def index
    @movies = current_user.movies
    userinfo
    render :index
  end

  def create
    @movie = Movie.find_or_create_by(tmdb_id: params[:tmdb_id])
    @movie.update(movie_params)
    if current_user.movies << @movie
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroymovie
    if params[:tmdb_id]
      @movie = Movie.find_by(tmdb_id: params[:tmdb_id]).id
      @stacking = Stacking.where(user_id: current_user.id, media_id: @movie, media_type: "Movie")
      @stacking.destroy_all
    elsif (params[:movie_id] && params[:movie_id] != "undefined")
      @stacking = Stacking.where(user_id: current_user.id, media_id: params[:movie_id], media_type: "Movie")
      @stacking.destroy_all
    end
  end

  def moviecompletionstatus
    if params[:tmdb_id]
      @movie = Movie.find_by(tmdb_id: params[:tmdb_id]).id
      @stacking = Stacking.where(user_id: current_user.id, media_id: @movie, media_type: "Movie")
      if params[:finished] == true
        @stacking.update_all(finished: true)
      else
        @stacking.update_all(finished: false)
      end
    else
      @stacking = Stacking.where(user_id: current_user.id, media_id: params[:movie_id], media_type: "Movie")
      if params[:finished] == true
        @stacking.update_all(finished: true)
      else
        @stacking.update_all(finished: false)
      end
    end
  end

  def movieaddasfinished
    @movie = Movie.find_or_create_by(tmdb_id: params[:movie][:tmdb_id])
    @movie.update(moviefinished_params)
    if current_user.movies << @movie
      render json: @user, status: :created
    else
      render json: @show.errors, status: :unprocessable_entity
    end
    @stacking = Stacking.where(user_id: current_user.id, media_id: @movie.id, media_type: "Movie")
    if params[:finished] == true
      @stacking.update_all(finished: true)
    else
      @stacking.update_all(finished: false)
    end
  end


  private
    def movie_params
      params.permit(:name, :tmdb_id, :date, :summary, :movie_art, :genre, :runtime)
    end

    def moviefinished_params
      params.require(:movie).permit(:name, :tmdb_id, :date, :summary, :movie_art, :genre, :runtime)
    end

end
