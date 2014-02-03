class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :user, index: true
      t.integer :level
      t.integer :score

      t.timestamps
    end
  end
end
