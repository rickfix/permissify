module Permissify
  module Controller

    include Permissify::Common

     def permissions # interface used by Permissfy::Common.allowed_to?
       @applicable_permissions ||= {}
       @permissions ||= construct_permissions
     end

     def log_permissions
       message = "*** PermissifyController permissions: #{@permissions.inspect}"
       defined?(logger) ? logger.debug(message) : puts(message)
     end
     
    private

    def construct_permissions
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
    
    # @permissions lazy init on a per ability basis
    # - need AbilityClass.get(key), then init as needed...
    # ** might be handy to provide a means to log permissions at end of controller action
    #    (:after_filter?, :after_render? ensure?) to see what was checked...
    
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
