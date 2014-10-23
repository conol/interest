require "active_record"

db_name      = (ENV["DB"] || "sqlite3").to_sym
database_yml = File.expand_path("../database.yml", File.dirname(__FILE__))

raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample" unless File.exists?(database_yml)

ActiveRecord::Base.configurations = YAML.load_file(database_yml)
ActiveRecord::Base.establish_connection(db_name)
ActiveRecord::Base.connection
