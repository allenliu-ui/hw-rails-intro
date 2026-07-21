class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  def index
    @all_ratings = Movie.all_ratings

    # 1. Determine if incoming request has explicit ratings or sort params
    user_filtered = params[:ratings].present? || params.key?(:ratings)
    user_sorted   = params[:sort_by].present?

    # 2. Redirect logic: redirect ONLY if params are completely missing but session has saved values
    if !user_filtered && !user_sorted && (session[:ratings].present? || session[:sort_by].present?)
      flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by]) and return
    end

    # 3. Extract ratings
    if params[:ratings].present?
      @ratings_to_show = params[:ratings].respond_to?(:keys) ? params[:ratings].keys : params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings].present?
      @ratings_to_show = session[:ratings].respond_to?(:keys) ? session[:ratings].keys : session[:ratings]
    else
      @ratings_to_show = @all_ratings
    end

    # 4. Extract sorting
    if params[:sort_by].present?
      @sort_by = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    elsif session[:sort_by].present?
      @sort_by = session[:sort_by]
    else
      @sort_by = nil
    end

    # 5. Query Model
    @movies = Movie.with_ratings(@ratings_to_show, @sort_by)
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end