module Permissify
  module Generators
    class RoleGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_ability
        copy_file "role.rb", "app/models/role.rb"
        # also make the following?
        # d app/models/system_fixtures
        # f app/models/system_fixtures/roles.rb
        # d app/models/permissions
        # f app/models/permissions/roles.rb
      end
    end
  end
end
