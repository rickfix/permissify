module Permissify
  module ModelClass
    
    def create_seeds(seed_specifications)
      seed_specifications.each do |id, name|
        permissions_model = locate(id, name)
        permissions_model.permissions = send("#{underscored_name_symbol(name)}_permissions") # interface methods needed for each seeded model
        permissions_model.save
      end
    end

    def create_with_id(table, id, name)
      permissions = send("#{underscored_name_symbol(name)}_permissions")
      permissions_model = new
      permissions_model.name = name
      permissions_model.permissions = permissions
      permissions_model.save
      force_seed_id(table, permissions_model, id) # interface method : force_seed_id
      find(id)
    end
  
    def force_seed_id(table, permissions_model, id)
      # not sure if this is still needed, may differ depending on db adapter (written against mysql)
      ActiveRecord::Base.connection.execute "UPDATE #{table}s SET id=#{id} WHERE id=#{permissions_model.id};"
    end

    def locate(id, name)
      model_with_id   = find_by_id(id) # interface method : ActiveRecord::Base.find_by_id
      model_with_id ||= send("create_#{underscored_name_symbol(name)}") # interface methods needed for each seeded model
    end

    def underscored_name_symbol(name)
      name.to_s.downcase.gsub(':','').gsub('-','_').gsub(' ','_').gsub(/__*/,'_')
    end
    
  end
end
