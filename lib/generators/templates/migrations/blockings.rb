class InterestBlockingsMigration < ActiveRecord::Migration
  def change
    create_table :blockings do |t|
      t.belongs_to :blocker, polymorphic: true, null: false
      t.belongs_to :blockee, polymorphic: true, null: false

      t.timestamps
    end

    add_index :blockings, [:blocker_id, :blocker_type]
    add_index :blockings, [:blockee_id, :blockee_type]
  end
end
