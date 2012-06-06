module RolesHelper
  include PermissionsHelper
  def all_roles_grouped_by_domain_type; all_roles.sort{|r1, r2| r1.domain_type <=> r2.domain_type}; end
  def additional_column1_value; @permissions_object.domain_type; end
  def additional_column2_value; "#{@permissions_object.users.count} users"; end
  def all_roles; @lazy_all_roles ||= Role.all; end
end
