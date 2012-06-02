module Permissify
  module Controller
        
    def domain_permissions
      return current_entity.permissions_union if current_user.nil? # public pages allow corp/brand/merchant product permissions
      return current_user.permissions_union unless current_entity # admin, by convention, not subscribed to any products
      current_user.permissions_intersection(current_entity.permissions_union)
    end

    def allowed_to?(action, permission_category)
      @permissions ||= domain_permissions
      (@permissions["#{permission_category}_#{action}"]['0'] == true rescue false)
    end
    
  end
end
