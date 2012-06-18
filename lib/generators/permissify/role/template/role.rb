class Role < ActiveRecord::Base
  DOMAIN_TYPES = %w(Admin Dealer Corporation Brand Merchant)
  # DOMAIN_TYPES = %w(Admin Operations CallCenter)
  include Permissify::Model
  # is_paranoid
  # default_scope :conditions => {:deleted_at => nil}, :order => "roles.name"
  has_and_belongs_to_many :users
  validates_presence_of   :name, :domain_type
  validates_uniqueness_of :name
  before_create :initialize_permissions
  before_validation :initialize_non_permission_values
  serialize :permissions
  has_and_belongs_to_many :managers, :class_name => 'Role', :join_table => :manages_roles, :association_foreign_key => :manage_id, :foreign_key => :role_id
  has_and_belongs_to_many :manages, :class_name => 'Role', :join_table => :manages_roles, :association_foreign_key => :role_id, :foreign_key => :manage_id
  
  class << self
    include Permissify::ModelClass
    include SystemFixtures::Roles

    def force_seed_id(table, permissions_model, id)
      # not sure if this is still needed, may differ depending on db adapter (written against mysql)
      ActiveRecord::Base.connection.execute "UPDATE #{table}s SET id=#{id} WHERE id=#{permissions_model.id};"
    end
  end
  
  def initialize_non_permission_values
    establish_from_permissions_model.nil? ? default_non_permissions_values : copy_non_permissions_values
  end
  
  def default_non_permissions_values
    self.domain_type = DOMAIN_TYPES.last if self.domain_type.blank?
    self.name = self.name.gsub("'","")
  end
  
  def copy_non_permissions_values
    self.domain_type = self.from_permissions_model.domain_type
    self.managers = self.from_permissions_model.managers
    self.manages = self.from_permissions_model.manages
  end
  
  def remove(permissions_list); permissions_list.each{|permission| self.permissions.delete(permission)}; save; end
end
