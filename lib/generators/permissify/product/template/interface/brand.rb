module PermissifiedProductsInterface
  module Brand
    def permissible_products
      self.corporation.products + self.products
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :permissible_products

  end
end
