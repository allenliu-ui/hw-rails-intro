class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list, sort_by = nil)
    # If ratings_list is empty/nil, default to showing all ratings
    ratings_to_query = ratings_list.present? ? ratings_list : all_ratings

    movies = where(rating: ratings_to_query)

    allowed_sorts = ['title', 'release_date']
    if allowed_sorts.include?(sort_by)
      movies = movies.order(sort_by => :asc)
    end

    movies
  end
end