class CreateCastMembers < ActiveRecord::Migration
  def change
    create_table :cast_members do |t|
      t.references :movie, index: true
      t.references :person, index: true

      t.timestamps
    end
  end
end
