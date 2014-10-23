require "active_support"
require "active_support/core_ext/string/inflections"
require "active_record"

ActiveRecord::Schema.define version: 0 do
  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stuffs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end

%w(followings).each do |table_name|
  ActiveRecord::Base.connection.drop_table table_name if ActiveRecord::Base.connection.table_exists?(table_name)
  require File.expand_path("../../lib/generators/templates/migrations/#{table_name}", File.dirname(__FILE__))
  "Interest#{table_name.camelize}Migration".constantize.migrate :up
end
