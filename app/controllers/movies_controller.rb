class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.ratings.map do |rating| 
      rating.rating
    end
    is_redirect = false
    
   
    if params[:ratings] and not params[:ratings].empty? 
      session[:ratings] = params[:ratings].keys
      @ratings_to_show = params[:ratings].keys
    elsif session[:ratings]
      #is_redirect = true
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = @all_ratings
    end
    

    @title_f = "hilite bg-warning"
    @title_r = "hilite bg-warning"
    #sort_type = params[:sort_type]
    #if sort_type and sort_type == 'title'
    #  @title_f = 'hilite'
    #elsif session[:sort_type]
    #  sort_type = session[:sort_type]
    #  @release_date_f = 'hilite'
    #end
    
    #if params[:ratings] != session[:ratings] || params[:sort_type] != session[:sort_type]
    #  session[:ratings] = params[:ratings]
    #  session[:sort_type] = params[:sort_type]
    #  redirect_to movies_path({sort_type: sort_type, ratings_to_show: @ratings_to_show})
    #end  
    
    if params[:order]
      @sort_type = params[:order]
      session[:order] = @sort_type
      @title_f = "hilite bg-warning"
      puts("hello1")
    else
      @sort_type = ''
      @title_f = "hilite bg-warning"
      puts("hello3")
    end
    
    
    @title_f = "hilite bg-warning"
    
    
    if is_redirect
     
      redirect_to movies_path({sort_type: @sort_type, ratings_to_show: @ratings_to_show, title_f: @title_f, title_r: @title_r})
    end

    @movies = Movie.with_ratings(@ratings_to_show)
    
    
    
    #@sort_type = @sort_type.to_sym
    puts("hello")
    puts(@sort_type)
    puts("sad")
    if @sort_type == "title" 
      puts("well?")
      @movies = @movies.order("title")
    end
    if @sort_type == "release_date"
      @movies = @movies.order :release_date 
    end
    
    
    
      
    
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
  
  

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
