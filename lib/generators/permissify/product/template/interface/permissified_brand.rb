module Permissified
  module Brand
    def permissible_products
      self.corporation.products + self.products
    end
  end
end
