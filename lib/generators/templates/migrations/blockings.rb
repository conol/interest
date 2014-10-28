class InterestBlockingsMigration < ActiveRecord::Migration
  def change
    create_table :blockings do |t|
      t.belongs_to :blocker, polymorphic: true, null: false
      t.belongs_to :blockee, polymorphic: true, null: false

      t.timestamps
    end

    add_index :blockings, [:blocker_id, :blocker_type], name: :index_blockings_blocker
    add_index :blockings, [:blockee_id, :blockee_type], name: :index_blockings_blockee
    add_index :blockings, [:blocker_id, :blocker_type, :blockee_id, :blockee_type], unique: true, name: :index_blockings_uniqueness
  end
end
