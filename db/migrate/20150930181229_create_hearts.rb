class CreateHearts < ActiveRecord::Migration
  def change
    create_table :hearts do |t|
      t.references :user, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true
      t.string :comment

      t.timestamps null: false
    end
  end
end
