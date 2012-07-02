module Permissify
  module Controller

    include Permissify::Common

    def permission(action, category) # interface used by Permissfy::Common.allowed_to?
      @permissions ||= construct_permissions # TODO : get lazier?
      permissible?(@permissions, action, category)
    end

    private

    def construct_permissions
      @applicable_permissions = {}
      permissions = {}
      Ability.all.each { |ability| permissions[ ability[:key] ] = authorized?(ability) }
      # puts "*** PERMISSIONS: #{permissions.inspect} ***"
      permissions
    end
    
    def authorized?(ability, key = ability[:key], applicablity = ability[:applicability], requires_any_or_all = ability[:any_or_all])
      # puts "AUTHORIZED?: ability: #{key}, #{applicablity}, #{requires_any_or_all}"
      authorizations = applicablity.collect{|applicable| applicable_authorization(applicable, key) }
      { '0' => authorizations.send(requires_any_or_all) }
    end
    
    def applicable_authorization(applicable, key)
      (permission = applicable_permissions(applicable)[key]) && permission['0'] == true
    end
    
    def applicable_permissions(applicablity)
      @applicable_permissions[applicablity] ||= permissified_model_permissions(applicablity)
    end
    
    def permissified_model_permissions(applicablity)

      # There is some app-specific glue between the *applicability* tags specified when *abilities* are created (abilities.rb)
      #   and the ability/permission applicability that a permissifed object obtained from an app-supplied controller method governs.
      # In more tangible terms:
      # - the User obtained from the controller method 'current_user'
      #   contributes permissions for abilities which apply to the 'Role' applicability tag
      # - the merchant (or brand or ...) obtained from the controller method 'current_entity'
      #   contributes permissions for abilities which apply to the 'Product' applicability tag
      
      # Define PERMISSIFY in your application_controller when your app does not conform with the conventional_permissify_map.
      
      permissify_map = defined?(self.class::PERMISSIFY) ? self.class::PERMISSIFY : conventional_permissify_map
      permissified_model_method = permissify_map[applicablity]
      permissified_model = send(permissified_model_method)
      permissified_model ? permissified_model.permissions : Hash.new({})
    end
    
    def conventional_permissify_map
      { Role::PERMISSIFIED_ABILITY_APPLICABILITY => :current_user,
        Product::PERMISSIFIED_ABILITY_APPLICABILITY => :current_entity,
      }
    end
  end
end
