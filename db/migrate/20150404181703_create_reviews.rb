class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body, null: false
      t.integer :user_id, null: false
      t.integer :band_id, null: false
      t.integer :venue_id, null: false

      t.timestamps
    end
  end
end
