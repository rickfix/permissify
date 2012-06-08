module Permissify
  module Aggregate
    attr_accessor :abilities
  
    def permissions_union
      @union ||= construct_union
      @working_permissions = @union
    end
  
    def permissions_intersection(product_permissions)
      @intersection ||= construct_intersection
      @working_permissions = @intersection
    end
    
    def allowed_to?(action, feature)
      @working_permissions ||= permissions_union
      (@working_permissions["#{feature}_#{action}"]['0'] == true rescue false)
    end

    def viewable?(feature);       allowed_to?(:view,    feature); end
    def createable?(feature);     allowed_to?(:create,  feature); end
    def updateable?(feature);     allowed_to?(:update,  feature); end
    def deleteable?(feature);     allowed_to?(:delete,  feature); end
    def subscribed_to?(feature);  allowed_to?(:on,      feature); end
  
    private

    def construct_union
      union = {}
      permissified_models = self.send(self.class::PERMISSIFIED_ASSOCIATION)
      permissions_hashes = permissified_models.collect(&:permissions)
      permissions_hashes.each do |permissions_hash|
        permissions_hash.each do |key, descriptor|
          descriptor ||= {'0' => false}
          if union[key].nil?
            union[key] = descriptor
          else
            arbitrate(union, descriptor, key, :max)
          end
          union[key]['0'] = (union[key]['0'] == true || descriptor['0'] == '1')
        end
      end
      union
    end
    
    def arbitrate(aggregation, other_descriptor, key, min_or_max) # assuming all permission 'args' are integers stored as strings
      1.upto(other_descriptor.size-1) do |i|
        is = i.to_s
        aggregation[key][is] = [aggregation[key][is].to_i, other_descriptor[is].to_i].send(min_or_max) # .to_s ?
      end
    end

    # TODO : flush out intersection stuff in corp/brand/business products phase
    # def construct_intersection
    #   intersection = {}
    #   permissions_union
    # 
    #   # TODO : Product/Role references should be plugged-in...
    #   # - could aggregate keep track of class names that it is included in?
    #   # - there is a lot tangled up in here...
    #   Ability.all_for(%w(Product Role)).each do |ability|
    #     key = ability[:key]
    #     descriptor = @union[key]
    #     product_descriptor = product_permissions[key]
    #     if permissable?(descriptor) && permissable?(product_descriptor)
    #       intersection[key] = descriptor
    #       arbitrate(intersection, product_descriptor, key, :min)
    #     else
    #       intersection[key] = null_permission
    #     end
    #   end
    # 
    #   include_permissions_unless_common_to_role_and_product('Product', product_permissions)
    #   include_permissions_unless_common_to_role_and_product('Role', @union)
    #   intersection
    # end
    # 
    # def permissable?(descriptor)
    #   descriptor && (descriptor['0'] == true || descriptor['0'] == '1')
    # end
    # 
    # def include_permissions_unless_common_to_role_and_product(applicability_type, applicable_permissions)
    #   Ability.all_for(applicability_type).each do |ability|
    #     key = ability[:key]
    #     descriptor = applicable_permissions[key]
    #     unless @intersection.has_key?(key)
    #       if permissable?(descriptor)
    #         descriptor['0'] = true
    #         @intersection[key] = descriptor
    #         arbitrate(@intersection, descriptor, key, :min)
    #       else
    #         @intersection[key] = null_permission
    #       end
    #     end
    #   end
    # end
    # 
    # def null_permission
    #   {'0' => false, '1' => 0}
    # end
  end
end
