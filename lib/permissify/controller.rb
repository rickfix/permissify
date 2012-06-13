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
      permissified_model_method = self.class::PERMISSIFY[applicablity]
      permissified_model = send(permissified_model_method)
      permissified_model ? permissified_model.permissions : Hash.new({})
    end
    
  end
end
