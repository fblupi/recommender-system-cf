# Get k-nearest neighbourhoods of a user and recommend films using collaborative filtering with Pearson correlation
class Recommender
  def initialize(ratings, avg_ratings, my_ratings)
    @ratings = ratings
    @avg_ratings = avg_ratings
    @my_ratings = my_ratings
    @my_avg_rating = 0.0
    @my_ratings.each_value do |v|
      @my_avg_rating += v
    end
    @my_avg_rating /= @my_ratings.length
  end

  def get_neighbourhoods(num)
    @neighbourhoods = {}
    @ratings.each_key do |user|
      matches = []
      @my_ratings.each_key do |movie|
        matches.push(movie) if @ratings[user].key?(movie)
      end
      if matches.length > 0
        numerator = 0.0
        user_denominator = 0.0
        other_user_denominator = 0.0
        matches.each do |movie|
          u = @my_ratings[movie] - @my_avg_rating
          v = @ratings[user][movie] - @avg_ratings[user]
          numerator += u * v
          user_denominator += u * u
          other_user_denominator += v * v
        end
        match_rate = user_denominator == 0 || other_user_denominator == 0 ?
                         0 : numerator / (Math.sqrt(user_denominator) * Math.sqrt(other_user_denominator))
      else
        match_rate = 0
      end
      @neighbourhoods[user] = match_rate
    end
    @neighbourhoods = @neighbourhoods.sort_by {|_, v| v }.reverse.first(num).to_h
  end

  def get_recommendations(movies, num)
    predicted_ratings = {}
    movies.each_key do |movie|
      unless @my_ratings.key?(movie)
        numerator = 0.0
        denominator = 0.0
        @neighbourhoods.each_key do |neighbourhood|
          if @ratings[neighbourhood].key?(movie)
            match_rate = @neighbourhoods[neighbourhood]
            numerator += match_rate * (@ratings[neighbourhood][movie] - @avg_ratings[neighbourhood])
            denominator += match_rate.abs
          end
        end
        if denominator > 0.0
          predicted_rating = @my_avg_rating + numerator / denominator
          predicted_rating = 5 if predicted_rating > 5
        else
          predicted_rating = 0.0
        end
        predicted_ratings[movie] = predicted_rating
      end
    end
    predicted_ratings.sort_by {|_, v| v}.reverse.first(num).to_h
  end
end