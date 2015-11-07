class CreateArtistRelationships < ActiveRecord::Migration
  def change

    create_table :artist_relationships do |t|
      t.integer :user_id
      t.integer :artist_id

      t.timestamps
    end
    add_index :artist_relationships, :user_id
    add_index :artist_relationships, :artist_id
    add_index :artist_relationships, [:user_id, :artist_id], unique: true
  end
end
