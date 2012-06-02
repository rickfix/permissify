module Permissify
  module Generators
    class ControllerGenerator < Rails::Generators::Base
      source_root File.expand_path('../template/interface', __FILE__)

      def generate_controller
        copy_file "permissified_controller.rb", "app/controllers/permissified_controller.rb"
      end
    end
  end
end
