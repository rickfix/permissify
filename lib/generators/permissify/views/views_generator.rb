module Permissify
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_views
        copy_file "permissions_helper.rb", "app/helpers/permissions_helper.rb"
        copy_file "roles_helper.rb", "app/helpers/roles_helper.rb"
        directory "permissions", "app/views/permissions"
        directory "roles", "app/views/roles"
      end
    end
  end
end
