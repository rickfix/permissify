module Permissify
  module Generators
    class AbilityGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_ability
        copy_file "ability.rb", "app/models/ability.rb"
        empty_directory "app/models/system_fixtures"
        copy_file "abilities.rb", "app/models/system_fixtures/abilities.rb"
      end
    end
  end
end
