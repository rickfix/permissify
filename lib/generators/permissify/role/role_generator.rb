module Permissify
  module Generators
    class RoleGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_role
        copy_file "role.rb", "app/models/role.rb"
        empty_directory "app/models/system_fixtures"
        copy_file "roles.rb", "app/models/system_fixtures/roles.rb"
      end
    end
  end
end
