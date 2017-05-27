# Read and store database of films
class Movies
  def initialize(filename = 'data/ml-data/u.item')
    @movies = {}
    File.open(filename, 'r').each_line do |line|
      data = line.split('|')
      id = data[0].to_sym
      name = data[1].to_s
      @movies[id] = name
    end
  end

  attr_reader :movies
end
