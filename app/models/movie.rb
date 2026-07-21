class Movie < ApplicationRecord
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings_list, sort_by = nil)
    # 1. Filter by ratings
    movies = ratings_list.present? ? where(rating: ratings_list) : all

    # 2. Apply sorting if a valid column name is provided
    allowed_sorts = ['title', 'release_date']
    if allowed_sorts.include?(sort_by)
      movies = movies.order(sort_by => :asc)
    end

    movies
  end
end