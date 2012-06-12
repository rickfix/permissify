module Permissify
  module Controller

    include Permissify::Common

     def permissions # interface used by Permissfy::Common.allowed_to?
       @permissions ||= contruct_permissions
     end

    private

    # def contruct_permissions
    #   e = current_entity
    #   u = current_user
    #   if u.nil?
    #     e ? e.permissions_union : {}  # public pages display according to just corp/brand/merchant product permissions
    #   else
    #     e ? u.permissions_intersection(e) : u.permissions_union
    #   end
    # end
    # 
    # def permissions_intersection(permissified_model)
    #   @intersection ||= construct_intersection(permissified_model)
    #   @working_permissions = @intersection
    # end

    def contruct_permissions
      applicable_permissions = {}
      PERMISSIFY.each do |permissified_model_method|
        permissified_model = send(permissified_model_method)
        applicability = permissified_model_method.class::PERMISSIFIED_ABILITY_APPLICABILITY
        applicable_permissions[applicability] = (permissified_model.permissions rescue {})
      end

      Ability.all.each do |ability|
        key = ability[:key]
        @permissions[key] = ability[:applicablity].collect{|applicable| applicable_permissions[applicable]}.all?
      end
    end
        
  end
end
