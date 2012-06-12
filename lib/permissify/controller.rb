module Permissify
  module Controller

    include Permissify::Common

     def permissions # interface used by Permissfy::Common.allowed_to?
       @permissions ||= determine_domain_permissions
     end

    private

    def determine_domain_permissions
      e = current_entity
      u = current_user
      if u.nil?
        e ? e.permissions_union : {}  # public pages display according to just corp/brand/merchant product permissions
      else
        e ? u.permissions_intersection(e) : u.permissions_union
      end
    end
    
    def permissions_intersection(permissified_model)
      @intersection ||= construct_intersection(permissified_model)
      @working_permissions = @intersection
    end
    
  end
end
