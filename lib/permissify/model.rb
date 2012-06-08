module Permissify
  module Model
    attr_accessor :from, :from_permissions_model
  
    def establish_from_permissions_model
      self.from_permissions_model ||= self.from.nil? ? nil : self.class.find(self.from)
    end
  
    def initialize_permissions
      self.permissions ||= self.from.nil? ? {} : establish_from_permissions_model.permissions
    end
  
    def allows?(ability_key)
      allowed = self.permissions[ability_key];
      # allowed && allowed['0']
      allowed && (allowed['0'] == '1') 
    end

    def remove_permissions(keys)
      keys = [keys] if keys.class != Array
      keys.each{ |k| self.permissions[k] = nil}
      self.save
    end
    
    def update_permissions(new_or_updated_permissions)
      self.permissions = self.permissions.merge(new_or_updated_permissions)
      self.save
    end
    
    def underscored_name_symbol
      self.class.underscored_name_symbol(self.name)
    end
  end
end
