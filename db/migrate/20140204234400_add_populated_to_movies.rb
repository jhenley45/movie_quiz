class AddPopulatedToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :populated, :boolean, default: false
  end
end
