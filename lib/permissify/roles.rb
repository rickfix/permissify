module Permissify::Roles
  include Permissify::Aggregate

  # inclusion of this module necessitates that the app's roles implementation includes:
  # 1. domain_type field
  # 2. define DOMAIN_TYPES as a ranked list of strings in implementation of Role/Permissify::Model-including class

  # NOTE: in example app, helper methods enforce only assigning domain_type-specific roles to users
  #       (an brand user can only be asigned roles that have a domain type of Brand).
  def primary_domain_type
    return nil if roles.empty?
    domain_types = roles.collect(&:domain_type)
    ranked_domain_types = roles.first.class::DOMAIN_TYPES
    ranked_domain_types.each do |ranked_domain_type|
      return ranked_domain_type if domain_types.include?(ranked_domain_type)
    end
    nil # unrecognized domain_type value(s)
  end
  
  # uncomment/reimplement methods as needed for example app/as more light shines...
  
  # def primary_domain_type; sorted_domain_types.first; end
  # def primary_role_name; role_list(:description).sort.first; end
  # def sorted_domain_types; role_list(:domain_type).sort; end
  # def manages_roles; role_list(:manages_roles); end
  # def manages_role_names; sorted_role_names(manages_roles); end
  # def role_list(collection_method); roles.collect(&collection_method).flatten.uniq; end
  # 
  # def can_create_and_modify(users, app_instance) # TODO : unit test for this
  #   role_names_that_this_user_can_manage = manages_role_names
  #   # 2 ways to go here : must be able to manage *all* or *any* of a user's roles.
  #   # Chose *all* to prevent lower ranking users from demoting higher ranking users
  #   users.select do |u|
  #     u_role_names = sorted_role_names(u.roles)
  #     ! u_role_names.blank? && (role_names_that_this_user_can_manage & u_role_names) == u_role_names
  #   end
  #   users.delete_if{|u| !u.instances.include?(app_instance)}
  #   return users
  # end
  # 
  # def sorted_role_names(roles); roles.collect(&:name).sort; end
end
