class CreateMovieSearches < ActiveRecord::Migration
  def change
    create_table :movie_searches do |t|
      t.text :title
      t.integer :tmdb_id

      t.timestamps
    end
  end
end
