require_relative 'movies'
require_relative 'ratings'
require_relative 'recommender'

NUM_RATINGS = 20
NUM_NEIGHBOURHOODS = 10
RANDOM_RATINGS = true

m = Movies.new
r = Ratings.new

my_ratings = {}

random = Random.new
num_movies = m.movies.length

NUM_RATINGS.times do
  id_movie = random.rand(1..num_movies).to_s.to_sym
  while my_ratings.key?(id_movie)
    id_movie = random.rand(1..num_movies).to_s.to_sym
  end

  if RANDOM_RATINGS
    rating = random.rand(1..5)
  else
    puts "Movie: #{m.movies[id_movie]}"
    puts 'Enter your rating (1-5): '
    rating = gets.chomp.to_f
    while rating < 1 || rating > 5
      puts 'Invalid rating. Enter your rating (1-5): '
      rating = gets.chomp.to_f
    end
  end

  my_ratings[id_movie] = rating
end

rec = Recommender.new(r.ratings, r.average_rating, my_ratings)
rec.get_neighbourhoods(NUM_NEIGHBOURHOODS)
