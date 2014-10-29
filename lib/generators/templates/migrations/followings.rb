class InterestFollowingsMigration < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.belongs_to :follower, polymorphic: true, null: false
      t.belongs_to :followee, polymorphic: true, null: false
      t.string :status, null: false

      t.timestamps
    end

    add_index :followings, [:follower_id, :follower_type], name: :index_followings_follower
    add_index :followings, [:followee_id, :followee_type], name: :index_followings_followee
    add_index :followings, [:follower_id, :follower_type, :followee_id, :followee_type], unique: true, name: :index_followings_uniqueness
  end
end
