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
 
  response = Typhoeus.get("www.omdbapi.com", :params => {:s => "#{search_str}"})
 # Modify the html output so that a list of movies is provided.
  raw_movie_data_arr_of_hashes = JSON.parse(response.body)["Search"]


  arr_of_titles = []
  raw_movie_data_arr_of_hashes.each {|movie_hash| arr_of_titles << movie_hash['Title']}
  final_movie_list = []
  # arr_of_titles.each { |title| fin }

  html_str = "<html><head><title>Movie Search Results</title></head><body><h1>Movie Results</h1>\n<ul>"
  html_str += "<li>#{arr_of_titles}</li></ul></body></html>"
  
end

# get '/poster/:imdb' do |imdb_id|
#   # Make another api call here to get the url of the poster.
#   html_str = "<html><head><title>Movie Poster</title></head><body><h1>Movie Poster</h1>\n"
#   html_str = "<h3>#{imdb_id}</h3>"
#   html_str += '<br /><a href="/">New Search</a></body></html>'

# end

