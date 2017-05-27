require_relative 'movies'
require_relative 'ratings'

NUM_RATINGS = 20
RANDOM_RATINGS = false

m = Movies.new

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
    rating = gets.chomp.to_i
    while rating < 1 || rating > 5
      puts 'Invalid rating. Enter your rating (1-5): '
      rating = gets.chomp.to_i
    end
  end

  my_ratings[id_movie] = rating
end