require 'rails/generators/active_record'

module ActsInRelation
  module Generators
    class ActionGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      argument :name, required: true, banner: '[action] --source=[source] --target=[target]'

      class_option :source, required: true, aliases: '-s'
      class_option :target, required: true, aliases: '-t'

      def copy_migration
        if migration_exists?
          migration_template 'add.rb.erb', "db/migrate/add_columns_to_#{table_name}.rb"
        else
          migration_template 'create.rb.erb', "db/migrate/create_#{table_name}.rb"
        end
      end

      private

      def migration_exists?
        Dir.glob("#{migration_path}/[0-9]*_*.rb").grep(/\d+_create_#{table_name}.rb$/).present?
      end

      def migration_path
        Rails.root.join('db/migrate')
      end

      def table_name
        name.downcase.pluralize
      end
    end
  end
end
