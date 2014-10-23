class InterestFollowingsMigration < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.belongs_to :follower, polymorphic: true, null: false
      t.belongs_to :followee, polymorphic: true, null: false

      t.timestamps
    end

    add_index :followings, [:follower_id, :follower_type]
    add_index :followings, [:followee_id, :followee_type]
  end
end
