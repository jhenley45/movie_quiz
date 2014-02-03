class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :user, index: true
      t.integer :score, default: 0
      t.integer :level, default: 1
      t.integer :level_up, default: 0

      t.timestamps


    end
  end
end
