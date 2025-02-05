class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date,:sort_by,:ratings)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @checkRatings = params[:ratings] || session[:ratings] || {}
    if @checkRatings == {}
      @checkRatings = @all_ratings
    else
      @checkRatings = @checkRatings.keys
    end
    sort_by = params[:sort_by] || session[:sort_by]
    
    if session[:sort_by] != params[:sort_by] or session != params[:ratings]
      session[:sort_by]=params[:sort_by] || session[:sort_by]
      session[:ratings]=params[:ratings] || session[:ratings] || {}
    end
    
    @movies = Movie.where(:rating => @checkRatings).order(sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
