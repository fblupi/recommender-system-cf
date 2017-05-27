# Read and store database of films
class Movies
  def initialize(filename = 'data/ml-data/u.item')
    @movies = {}
    File.open(filename, 'r').each_line do |line|
      data = line.split('|')
      @movies[data[0].to_sym] = data[1].to_s
    end
  end

  def size
    @movies.length
  end

  def get_name(id)
    @movies[id]
  end
end
