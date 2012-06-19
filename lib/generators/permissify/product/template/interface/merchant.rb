module PermissifiedProductsInterface
  module Merchant
    def permissible_products
      self.corporation.products + self.brand.products + self.products
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products
    # PERMISSIFIED_ABILITY_APPLICABILITY = Product::PERMISSIFIED_ABILITY_APPLICABILITY

  end
end
