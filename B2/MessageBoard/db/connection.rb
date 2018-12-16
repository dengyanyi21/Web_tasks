require 'active_record'
require 'yaml'

db_config = YAML.safe_load(File.open('db/database.yml'))
ActiveRecord::Base.establish_connection(db_config)