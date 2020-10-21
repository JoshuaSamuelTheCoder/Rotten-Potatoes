class Movie < ActiveRecord::Base
  def self.ratings
    return select(:rating).group(:rating)
  end
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
    if ratings_list.nil? || ratings_list.empty? 
      return []
    else
      return Movie.where('rating IN (?)', ratings_list)
    end
  end
end
