module PermissifiedProductsInterface
  module Merchant
    def permissible_products
      self.corporation.products + self.brand.products + self.products
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :permissible_products

  end
end
