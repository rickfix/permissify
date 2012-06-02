module Permissify
  module Generators
    class ProductGenerator < Rails::Generators::Base
      source_root File.expand_path('../template', __FILE__)

      def generate_product
        copy_file "product.rb", "app/models/product.rb"
        copy_file "/interface/permissified_merchant.rb", "app/models/permissified_merchant.rb"
        copy_file "/interface/permissified_brand.rb", "app/models/permissified_brand.rb"
        # directory instead?
        # d app/models/permissfy_interfaces
        # f app/models/permissfy_interfaces/merchant.rb
        # f app/models/permissfy_interfaces/brand.rb
      end
    end
  end
end
