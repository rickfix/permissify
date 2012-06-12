module Permissify
  module Common

    def allowed_to?(action, ability_category)
      (permissions["#{ability_category}_#{action}"]['0'] == true rescue false)
    end

    def viewable?(ability_category);       allowed_to?(:view,    ability_category); end
    def createable?(ability_category);     allowed_to?(:create,  ability_category); end
    def updateable?(ability_category);     allowed_to?(:update,  ability_category); end
    def deleteable?(ability_category);     allowed_to?(:delete,  ability_category); end
    def subscribed_to?(ability_category);  allowed_to?(:on,      ability_category); end
    
    def arbitrate(aggregation, other_descriptor, key, min_or_max) # assuming all permission 'args' are integers stored as strings
      # puts "*** other_descriptor: #{other_descriptor.inspect}"
      # other_descriptor.each do |key_index, key_value|
      #   puts "*** key_index: #{key_index}, key_value: #{key_value}"
      #   aggregation[key][key_index] = [aggregation[key][key_index], key_value.to_i].send(min_or_max) # .to_s ?
      # end
      1.upto(other_descriptor.size-1) do |i|
        is = i.to_s
        aggregation[key][is] = [aggregation[key][is].to_i, other_descriptor[is].to_i].send(min_or_max) # .to_s ?
      end
    end
    
  end
end
