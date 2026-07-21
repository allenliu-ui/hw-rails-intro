class Movie < ApplicationRecord
  # Returns an array of all possible ratings
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  # Returns an ActiveRecord relation of movies matching the given ratings
  def self.with_ratings(ratings_list)
    if ratings_list.present?
      # Case-insensitive query using ActiveRecord 'where'
      where(rating: ratings_list)
    else
      # If ratings_list is nil or empty, return ALL movies
      all
    end
  end
end
