module Permissify::Roles
  include Permissify::Aggregate
  
  def primary_domain_type; sorted_domain_types.first; end
  def primary_role_name; role_list(:description).sort.first; end
  def sorted_domain_types; role_list(:domain_type).sort; end
  def manages_roles; role_list(:manages_roles); end
  def manages_role_names; sorted_role_names(manages_roles); end
  def role_list(collection_method); roles.collect(&collection_method).flatten.uniq; end
  
  def can_create_and_modify(users, app_instance) # TODO : unit test for this
    role_names_that_this_user_can_manage = manages_role_names
    # 2 ways to go here : must be able to manage *all* or *any* of a user's roles.
    # Chose *all* to prevent lower ranking users from demoting higher ranking users
    users.select do |u|
      u_role_names = sorted_role_names(u.roles)
      ! u_role_names.blank? && (role_names_that_this_user_can_manage & u_role_names) == u_role_names
    end
    users.delete_if{|u| !u.instances.include?(app_instance)}
    return users
  end
  
  def sorted_role_names(roles); roles.collect(&:name).sort; end
end
