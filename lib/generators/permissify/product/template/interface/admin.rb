module PermissifiedProductsInterface
  module Admin
    def permissible_products
      []
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products
    # PERMISSIFIED_ABILITY_APPLICABILITY = Product::PERMISSIFIED_ABILITY_APPLICABILITY

  end
end
