# Get k-nearest neighbourhood of a user and recommend films using collaborative filtering with Pearson correlation
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

  def get_neighbourhood(k)
    @neighbourhood = {}
    @ratings.each_key do |user|
      matches = []
      @my_ratings.each_key do |movie|
        matches.push movie if @ratings[user].key? movie
      end
      if matches.any?
        num = 0.0
        user_den = 0.0
        other_user_den = 0.0
        matches.each do |movie|
          u = @my_ratings[movie] - @my_avg_rating
          v = @ratings[user][movie] - @avg_ratings[user]
          num += u * v
          user_den += u * u
          other_user_den += v * v
        end
        if user_den.zero? || other_user_den.zero?
          match_rate = 0
        else
          match_rate = num / (Math.sqrt(user_den) * Math.sqrt(other_user_den))
        end
      else
        match_rate = 0
      end
      @neighbourhood[user] = match_rate
    end
    @neighbourhood = @neighbourhood.sort_by { |_, v| v }.reverse.first(k).to_h
  end

  def get_recommendations(movies, k)
    predicted_ratings = {}
    movies.each_key do |movie|
      unless @my_ratings.key? movie
        num = 0.0
        den = 0.0
        @neighbourhood.each_key do |neighbour|
          if @ratings[neighbour].key? movie
            match_rate = @neighbourhood[neighbour]
            num += match_rate * (@ratings[neighbour][movie] - @avg_ratings[neighbour])
            den += match_rate.abs
          end
        end
        if den > 0.0
          predicted_rating = @my_avg_rating + num / den
          predicted_rating = 5 if predicted_rating > 5
        else
          predicted_rating = 0.0
        end
        predicted_ratings[movie] = predicted_rating
      end
    end
    predicted_ratings.sort_by { |_, v| v }.reverse.first(k).to_h
  end
end