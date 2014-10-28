class InterestFollowRequestsMigration < ActiveRecord::Migration
  def change
    create_table :follow_requests do |t|
      t.belongs_to :requester, polymorphic: true, null: false
      t.belongs_to :requestee, polymorphic: true, null: false

      t.timestamps
    end

    add_index :follow_requests, [:requester_id, :requester_type], name: :index_follow_requests_requester
    add_index :follow_requests, [:requestee_id, :requestee_type], name: :index_follow_requests_requestee
    add_index :follow_requests, [:requester_id, :requester_type, :requestee_id, :requestee_type], unique: true, name: :index_follow_requests_uniqueness
  end
end
