class ProductsController < PermissionsController
  def set_permissions_class; set_the_permissions_class(Products, :product, 'product_', 'Product', 'Products'); end
  def set_permissions_object; @product = @permissions_object; end
end

