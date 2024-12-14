class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.integer :comments_count
      t.integer :likes_count
      t.boolean :private
      t.integer :own_photos_count

      t.timestamps
    end
  end
end
