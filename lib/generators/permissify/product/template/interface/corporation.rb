module PermissifiedProductsInterface
  module Corporation
    def permissible_products
      self.products
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products

  end
end
