require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  

    def self.table_name
        self.to_s.downcase.pluralize
    end

    def self.column_names
        #get sql info for column names into hash
        table_data = DB[:conn].execute("PRAGMA table_info(#{table_name})")

        #shovel column name value sinto hash
        column_names = []
        table_data.each do |table_col|
            column_names << table_col["name"]
        end
        column_names.compact
    end



end