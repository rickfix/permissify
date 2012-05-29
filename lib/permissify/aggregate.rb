module Permissions::Aggregate
  attr_accessor :abilities
  
  def permissions_union # [integer values].max
    @union ||= construct_union
  end
  
  def construct_union
    union = {}
    self.send(permissions_association).collect(&:permissions).each do |permissions_hash|
      permissions_hash.each do |key, descriptor|
        descriptor ||= {'0' => false}
        if union[key].nil?
          union[key] = descriptor
        else
          arbitrate(union, descriptor, key, :max)
        end
        union[key]['0'] = (union[key]['0'] == '1' || descriptor['0'] == '1')
      end
    end
    union
  end
  
  def permissions_intersection(product_permissions) # [integer values].min
    return @intersection if @intersection
    @intersection = {}
    permissions_union

    Ability.all_for(%w(Product Role)).each do |ability|
      key = ability[:key]
      descriptor = @union[key]
      product_descriptor = product_permissions[key]
      if permissable?(descriptor) && permissable?(product_descriptor)
        @intersection[key] = descriptor
        arbitrate(@intersection, product_descriptor, key, :min)
      else
        @intersection[key] = null_permission
      end
    end

    include_permissions_unless_common_to_role_and_product('Product', product_permissions)
    include_permissions_unless_common_to_role_and_product('Role', @union)
    @intersection
  end
  
  def permissable?(descriptor); descriptor && (descriptor['0'] == true || descriptor['0'] == '1'); end
  def subscribed_to?(feature); allowed_to?('on', feature); end
  def allowed_to?(action, feature); (permissions_union["#{feature}_#{action}"]['0'] == true rescue false); end
  
  def include_permissions_unless_common_to_role_and_product(applicability_type, applicable_permissions)
    Ability.all_for(applicability_type).each do |ability|
      key = ability[:key]
      descriptor = applicable_permissions[key]
      unless @intersection.has_key?(key)
        if permissable?(descriptor)
          descriptor['0'] = true
          @intersection[key] = descriptor
          arbitrate(@intersection, descriptor, key, :min)
        else
          @intersection[key] = null_permission
        end
      end
    end
  end
  
  private
  def arbitrate(aggregation, other_descriptor, key, min_or_max) # assuming all permission 'args' are integers stored as strings
    1.upto(other_descriptor.size-1) do |i|
      is = i.to_s; aggregation[key][is] = [aggregation[key][is].to_i, other_descriptor[is].to_i].send(min_or_max) # .to_s ?
    end
  end
  def null_permission; {'0' => false, '1' => 0}; end
  
  def permissions_association # kinda icky
    klass = self.respond_to?(:product_tiers) ? self.class : Business
    @permissions_association ||= {User => :roles, klass => :product_tiers}[self.class]
    @permissions_association ||= :permission_objects
  end
end
