class CreateArtistRelationships < ActiveRecord::Migration
  def change

    create_table :artist_relationships do |t|
      t.integer :user_id
      t.integer :artist_id

      t.timestamps
    end
    add_index :artist_relationships, :follower_id
    add_index :artist_relationships, :followed_id
    add_index :artist_relationships, [:follower_id, :followed_id], unique: true
  end
end
