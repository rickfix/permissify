module Permissify
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_views
        copy_file "role.rb", "app/views/role.rb"
        copy_file "roles.rb", "app/views/system_fixtures/roles.rb"

        directory "app/views/permissions"

        empty_directory "app/views/roles"
      end
    end
  end
end
