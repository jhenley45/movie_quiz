class AddDetailsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :populated, :boolean, default: false
  end
end
