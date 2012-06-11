module Permissify
  module Controller

    def allowed_to?(action, permission_category)
      (domain_permissions["#{permission_category}_#{action}"]['0'] == true rescue false)
    end
    
    private

    def domain_permissions
      @permissions ||= determine_domain_permissions
    end

    def determine_domain_permissions
      e = current_entity
      u = current_user
      if u.nil?
        e ? e.permissions_union : {}  # public pages display according to just corp/brand/merchant product permissions
      else
        e ? u.permissions_intersection(e.permissions_union) : u.permissions_union
      end
    end
    
  end
end
