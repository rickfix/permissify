module PermissifiedProductsInterface
  module Merchant
    def permissible_products
      self.corporation.products + self.brand.products + self.products
    end
  end
end
