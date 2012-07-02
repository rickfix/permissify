module Permissify
  module Generators
    class ProductGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_product
        
        copy_file "product.rb",   "app/models/product.rb"
        copy_file "products.rb",  "app/models/system_fixtures/products.rb"
        copy_file "controller.rb","app/controllers/products_controller.rb"
        copy_file "helper.rb",    "app/helpers/products_helper.rb"
        
        directory "interface",    "app/models/permissified_products_interface"
        directory "views",        "app/views/products"
        
      end
    end
  end
end
