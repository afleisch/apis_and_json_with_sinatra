require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'

get '/' do
  html = %q(
  <html><head><title>Movie Search</title></head><body>
  <h1>Find a Movie!</h1>
  <form accept-charset="UTF-8" action="/result" method="post">
    <label for="movie">Search for:</label>
    <input id="movie" name="movie" type="text" />
    <input name="commit" type="submit" value="Search" /> 
  </form></body></html>
  )
end

post '/result' do
  search_str = params[:movie]

  # Make a request to the omdb api here!
 
  response = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})

  str_of_movie_info = ""
 # Modify the html output so that a list of movies is provided.
  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  movie_raw_data = JSON.parse(response.body)

  movie__raw_data_arr_of_hashes = movie_raw_data["Search"] 

  movie__raw_data_arr_of_hashes.each {|movie_hash|
    html_str += "<ul><li><a href=/poster/#{movie_hash["imdbID"]}>#{movie_hash["Title"]}: 
    #{movie_hash["Year"]}</a></li></ul><br>" }

  html_str += "</body></html>"
  
end

get '/poster/:imdb' do |imdb_id|
  # Make another api call here to get the url of the poster.
  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  response = Typhoeus.get("www.omdbapi.com/?i=#{imdb_id}")

  id_hash= JSON.parse(response.body)
  poster_link = id_hash["Poster"]


  html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
  html_str = "<h3><a href = #{imdb_id}> </a></h3>"
  html_str +="<img src = #{poster_link}>"
  html_str += '<br /><a href="/">New Search</a></body></html>'

end

