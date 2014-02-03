class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :user, index: true
      t.integer :level, default: 0
      t.integer :score, default: 0

      t.timestamps


    end
  end
end
