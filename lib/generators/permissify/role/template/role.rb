class Role < ActiveRecord::Base
  DOMAIN_TYPES = %w(Admin Dealer Corporate Brand Merchant)
  include Permissions::Model
  # is_paranoid
  has_and_belongs_to_many :users, :order => "userable_type ASC"
  # default_scope :conditions => {:deleted_at => nil}, :order => "roles.name"
  validates_presence_of   :name, :domain_type
  validates_uniqueness_of :name
  before_create :initialize_permissions
  before_validation :initialize_non_permission_values
  serialize :permissions
  serialize :can_manage_roles
  after_save :propagate_managed_by
    
  class << self
    include Permissions::ModelClass
    include SystemFixtures::Roles
    def super_user;       locate(1, 'super user');      end
    def system_admin;     locate(2, 'system admin');    end
    def dealer_admin;     locate(3, 'dealer admin');    end
    def corporate_admin;  locate(4, 'corporate admin'); end
    def brand_admin;      locate(5, 'brand admin');     end
    def merchant_admin;   locate(6, 'merchant admin');  end
  end
  
  def initialize_non_permission_values
    establish_from_permissions_model.nil? ? default_non_permissions_values : copy_non_permissions_values
  end
  
  def default_non_permissions_values
    self.can_manage_roles ||= []
    self.domain_type = DOMAIN_TYPES.last if self.domain_type.blank?
    self.name = self.name.gsub("'","")
  end
  
  def copy_non_permissions_values
    self.domain_type = self.from_permissions_model.domain_type
    self.managed_by  = self.from_permissions_model.managed_by
    self.can_manage_roles = self.from_permissions_model.can_manage_roles
  end
  
  def manages_roles
    return [] if quoted_role_names.blank?
    self.class.find(:all, :conditions => ["name in (#{quoted_role_names})"], :order => :name)
  end
  
  def remove(permissions_list); permissions_list.each{|permission| self.permissions.delete(permission)}; save; end
  
  def quoted_role_names; self.can_manage_roles.collect{|n| "'#{n}'"}.join(', ') rescue []; end
  
  def managed_by=(role_name_list); @managed_by = role_name_list; end
  def managed_by
    @managed_by ||= Role.all.select{|r| r.can_manage_roles.include?(self.name)}.collect(&:name)
  end
  
  def propagate_managed_by
    Role.all.each{ |r| r.update_manages_roles(managed_by.include?(r.name), self.name) } unless @managed_by.nil?
  end
  
  def update_manages_roles(manages_role_name, role_name)
    old = self.manages_roles
    old = [] if old.blank?
    new_value = manages_role_name ? old | [role_name] : old - [role_name]
    update_attribute(:can_manage_roles, new_value) if old != new_value
  end
end
