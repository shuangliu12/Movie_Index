require 'sinatra'
require 'CSV'

MOVIE_FILENAME = 'movies.csv'

def import_csv(filename)
  movies = []
  CSV.foreach('movies.csv', headers:true) do |row|
    movies << row.to_hash
  end
  movies
end

get '/movies' do
  @all_movies = import_csv(MOVIE_FILENAME)
  @sorted = @all_movies.sort_by{|movie| movie['title']}

  @page_number = params[:page] || 1
  @query = params[:query]

  if @query == nil
  # start_index = 10*(@page_number-1)
  # end_index = 10*(@page_number-1)+9
  @each_page = @sorted[10*(@page_number.to_i-1)...10*(@page_number.to_i-1)+20]

  else
  @each_page = @all_movies.select do |movie|
    if movie['synopsis'] != nil
      movie['title'].include?(@query)||movie['synopsis'].include?(@query)
    else
      movie['title'].include?(@query)
    end
  end
end

 erb :movies
end


get '/movies/:movie_id' do
  @movie_id = params[:movie_id]
  @all_movies = import_csv(MOVIE_FILENAME)
 #movies_info =[{"title"=>'sunshine','id'=>'2'}]
  @movies_info = @all_movies.select do |movie|
     movie['id'] == @movie_id
    end
  erb :movie_id
end






set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
