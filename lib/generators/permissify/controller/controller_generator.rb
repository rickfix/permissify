module Permissify
  module Generators
    class ControllerGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_controller
        copy_file "permissions_controller.rb", "app/controllers/permissions_controller.rb"
      end
    end
  end
end
