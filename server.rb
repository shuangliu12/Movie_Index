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

get '/movies/:page' do
  @all_movies = import_csv(MOVIE_FILENAME)
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
