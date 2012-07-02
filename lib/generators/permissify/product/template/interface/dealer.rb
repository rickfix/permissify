module PermissifiedProductsInterface
  module Dealer
    def permissible_products
      self.products
    end

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products

  end
end
