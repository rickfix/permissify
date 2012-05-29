module Permissions::ModelClass
  def retire_permissions_objects(retire_sql)
    ActiveRecord::Base.connection.execute retire_sql
  end

  def create_seeds(table_name, seed_specifications)
    @model_class_seed_specifications = seed_specifications
    seed_specifications.each do |id, name|
      permissions_model = locate(id, name)
      permissions_model.permissions = send("#{underscored_name_symbol(name)}_permissions")
      permissions_model.save
    end
    ActiveRecord::Base.connection.execute "ALTER TABLE #{table_name} AUTO_INCREMENT = 101;"
  end

  def create_with_id(table, id, name)
    permissions = send("#{underscored_name_symbol(name)}_permissions")
    permissions_model = new
    permissions_model.name = name
    permissions_model.permissions = permissions
    permissions_model.save
    ActiveRecord::Base.connection.execute "UPDATE #{table}s SET id=#{id} WHERE id=#{permissions_model.id};"
    find(id)
  end
  
  def locate(id, name)
    model_with_id   = find_by_id(id)
    model_with_id ||= send("create_#{underscored_name_symbol(name)}")
  end

  def underscored_name_symbol(name)
    name.to_s.downcase.gsub('-','_').gsub(':','').gsub('  ',' ').gsub(' ','_')    
  end
end
