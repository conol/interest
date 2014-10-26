require "rails/generators"
require "rails/generators/active_record"

class InterestGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path("templates", File.dirname(__FILE__))

  def create_migration_file
    migration_template "migrations/followings.rb", "db/migrate/interest_followings_migration.rb"
    migration_template "migrations/blockings.rb", "db/migrate/interest_blockings_migration.rb"
  end

  def create_model
    copy_file "models/following.rb", "app/models/following.rb"
    copy_file "models/blocking.rb", "app/models/blocking.rb"
  end
end
