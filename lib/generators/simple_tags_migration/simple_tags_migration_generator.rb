require 'rails/generators/migration'
class SimpleTagsMigrationGenerator < Rails::Generators::Base 
  include Rails::Generators::Migration

  def create_migration
    migration_template 'migration.rb', "db/migrate/create_taggings.rb"
  end

  protected

  def self.source_root 
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))  
  end 

  def self.next_migration_number(dirname) #:nodoc:
    if ::ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
end
