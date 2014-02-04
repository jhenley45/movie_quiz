class AddDetailsToMovies < ActiveRecord::Migration
  def change
  	add_column :movies, :title, :text
    add_column :movies, :tmdb_id, :integer
  end
end
