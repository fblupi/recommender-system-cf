require_relative 'movies'
require_relative 'ratings'
require_relative 'recommender'

NUM_RATINGS = 20
NUM_NEIGHBOURHOODS = 10
NUM_RECOMMENDATIONS = 20
RANDOM_RATINGS = true

# import database
ml_movies = Movies.new
ml_ratings = Ratings.new

# get my ratings
my_ratings = {}
random = Random.new
num_movies = ml_movies.movies.length
NUM_RATINGS.times do
  id_movie = random.rand(1..num_movies).to_s.to_sym
  while my_ratings.key?(id_movie)
    id_movie = random.rand(1..num_movies).to_s.to_sym
  end

  if RANDOM_RATINGS
    rating = random.rand(1..5)
  else
    puts "Movie: #{ml_movies.movies[id_movie]}"
    puts 'Enter your rating (1-5): '
    rating = gets.chomp.to_f
    while rating < 1 || rating > 5
      puts 'Invalid rating. Enter your rating (1-5): '
      rating = gets.chomp.to_f
    end
  end

  my_ratings[id_movie] = rating
end

# generate recommendations
recommender = Recommender.new(ml_ratings.ratings, ml_ratings.average_rating, my_ratings)
recommender.get_neighbourhoods(NUM_NEIGHBOURHOODS)
recommendations = recommender.get_recommendations(ml_movies.movies, NUM_RECOMMENDATIONS)

# print results
recommendations.each do |k, v|
  puts "#{ml_movies.movies[k]}: #{v}"
end
