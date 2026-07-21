class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list, sort_by = nil)
    # If no ratings are passed, return no movies
    return Movie.none if ratings_list.blank?

    # 1. Filter by ratings
    movies = where(rating: ratings_list)

    # 2. Apply sorting if a valid column name is provided
    allowed_sorts = ['title', 'release_date']
    if allowed_sorts.include?(sort_by)
      movies = movies.order(sort_by => :asc)
    end

    movies
  end
end