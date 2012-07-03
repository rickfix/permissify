module PermissifiedProductsInterface
  module Admin

    include Permissify::Union
    PERMISSIFIED_ASSOCIATION = :products

  end
end
