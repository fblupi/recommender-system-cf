# Read and store ratings of films
class Ratings
  def initialize(filename = 'data/ml-data/u.data')
    @ratings = {}
    @average_rating = Hash.new(0)
    File.open(filename, 'r').each_line do |line|
      data = line.split(' ')
      id_user = data[0].to_sym
      id_movie = data[1].to_sym
      rating = data[2].to_f
      @ratings[id_user] = {} unless @ratings.key?(id_user)
      @ratings[id_user][id_movie] = rating
      @average_rating[id_user] += rating
    end
    @average_rating.each_key do |k|
      @average_rating[k] /= @ratings[k].length
    end
  end
end
