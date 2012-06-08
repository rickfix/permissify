require 'spec_helper'

describe Permissify::Roles do
  
  describe 'primary_domain_type' do
    ranked_domain_types = Roleish::DOMAIN_TYPES
    n = ranked_domain_types.length - 1
    (0..n).each do |i|
      subset_of_ranked_domain_types = ranked_domain_types[i..n]
      expected_primary_domain_type  = subset_of_ranked_domain_types[0]
      it "should return '#{expected_primary_domain_type}' when represented domain types are #{subset_of_ranked_domain_types.join(',')}" do
        new_user_with_roles( subset_of_ranked_domain_types.collect{|dt| new_role(dt) }.reverse )
        @u.primary_domain_type.should == expected_primary_domain_type
      end
    end
  end
  
  def new_user_with_roles(roles)
    @u = UserishWithRoles.new
    @roles = roles
    @u.roles = @roles
  end
  
  def new_role(domain_type)
    pm = Roleish.new
    pm.domain_type = domain_type
    pm
  end
end
