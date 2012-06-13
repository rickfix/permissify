module Permissify
  module Common

    def allowed_to?(action, ability_category)
      permission(action, ability_category) == true
    end

    def viewable?(ability_category);       allowed_to?(:view,    ability_category); end
    def createable?(ability_category);     allowed_to?(:create,  ability_category); end
    def updateable?(ability_category);     allowed_to?(:update,  ability_category); end
    def deleteable?(ability_category);     allowed_to?(:delete,  ability_category); end
    def subscribed_to?(ability_category);  allowed_to?(:on,      ability_category); end
    
    def permissible?(permissions_hash, action, category)
      key = Ability.key_for(action, category)
      (permission = permissions_hash[key]) && permission['0'] == true
    end

    def log_permissions
      message = "*** PermissifyController permissions: #{@permissions.inspect}"
      defined?(logger) ? logger.debug(message) : puts(message)
    end
    
    # NOTE : mothballed additional permission values...
    # def arbitrate(aggregation, other_descriptor, key, min_or_max) # assuming all permission 'args' are integers stored as strings
    #   1.upto(other_descriptor.size-1) do |i|
    #     is = i.to_s
    #     aggregation[key][is] = [aggregation[key][is].to_i, other_descriptor[is].to_i].send(min_or_max) # .to_s ?
    #   end
    # end
    
  end
end
