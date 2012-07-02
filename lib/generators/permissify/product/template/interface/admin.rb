module PermissifiedProductsInterface
  module Admin
    def permissible_products
      []
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products

  end
end
