module Permissify
  module Controller

    include Permissify::Common

     def permissions # interface used by Permissfy::Common.allowed_to?
       @permissions ||= construct_permissions
     end

    private

    def construct_permissions
      construct_applicable_permissions
      permissions = {}
      Ability.all.each { |ability| permissions[ ability[:key] ] = authorized?(ability) }
      # puts "*** PERMISSIONS: #{permissions.inspect} ***"
      permissions
    end
    
    def construct_applicable_permissions
      @applicable_permissions = {}
      self.class::PERMISSIFY.each do |permissified_model_method, applicability|
        permissified_model = send(permissified_model_method)
        # puts "PERMISSIFY: permissified_model_method: #{permissified_model_method}, applicability: #{applicability}, permissified_model: #{permissified_model}."
        @applicable_permissions[applicability] = permissified_model ? permissified_model.permissions : Hash.new({'0' => false})
      end
    end
    
    def authorized?(ability, key = ability[:key], applicablity = ability[:applicability], requires_any_or_all = ability[:any_or_all])
      # puts "AUTHORIZED?: ability: #{key}, #{applicablity}, #{requires_any_or_all}"
      authorizations = applicablity.collect{|applicable| applicable_authorization(applicable, key) }
      { '0' => authorizations.send(requires_any_or_all) }
    end
    
    def applicable_authorization(applicable, key)
      (permission = @applicable_permissions[applicable][key]) && permission['0'] == true
    end
    
  end
end
