class ProductsController < PermissionsController
  def set_permissions_class; set_the_permissions_class(Product, :product, 'product_', 'Product', 'Products'); end
  def set_permissions_object; @product = @permissions_object; end
  def set_permissions_object_specific_values(attrs); end
end

