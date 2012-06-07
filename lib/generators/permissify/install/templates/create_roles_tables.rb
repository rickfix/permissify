class CreateRolesTables < ActiveRecord::Migration
  def up
    
    create_table  :roles, :force => true do |t|
      t.string    :name, :limit => 31
      t.string    :domain_type, :limit => 31
      t.text      :can_manage_roles
      t.text      :permissions
      t.timestamps
    end
    
    # the 'manages_roles' join table facilitates the expression of which roles manage other roles. 
    # see role.rb HABTM managers and manages associations.
    create_table :manages_roles, :id => false, :force => true do |t|
      t.references :manage, :null => false
      t.references :role, :null => false
    end


    # NOTE 1: when associating roles to a model/table other than 'users',
    # the 'roles_users' join table, and its :user_id field, need to be renamed.
    
    # NOTE 2: roles can be associated to multiple models/tables.
    # create a join table for each model/table which roles are associated to.
    
    create_table :roles_users, :id => false, :force => true do |t|
      t.integer :role_id, :null => false
      t.integer :user_id, :null => false
    end

    # NOTE 3: add indexes as appropriate for your app.

  end

  def down
    drop_table :roles
    drop_table :manages_roles
    drop_table :roles_users
  end
  
end
