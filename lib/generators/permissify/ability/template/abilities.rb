module SystemFixtures::Abilities
  
  # required interface method : app Ability class must implement
  # - use Permissify::AbilityClass builder methods or *ml or whatever : just get @@abilities set
  def seed
    SPECIFY_ABILITIES_IN__APP__MODELS__SYSTEM_FIXTURES__ABILITIES

    # can organize permissions into categories that correspond to your client's/product team's view of app.
    # suggest playing with your Ability class and the builder methods in console.

    # NOTE : 'Role' and 'Product' references in following example are actually *class names*.
    # This is a name coupling (see Permissify::Union) that can be overriden.
    
    # applies_to_users_only = [User::PERMISSIFIED_ABILITY_APPLICABILITY]
    # add_category('Tabs', 'Tabs', applies_to_users_only, %w(Admin Dealer Corporate Brand Merchant))
    # { 'Roles'                 => 'Admin',
    #   'Admin Users'           => 'Admin',
    #   'Dealer Users'          => 'Dealer Admin',
    #   'Corporate Users'       => 'Corporate Admin',
    #   'Brand Users'           => 'Brand Admin',
    #   'Merchant Users'        => 'Merchant Admin',
    # }.each{ |category, section| add_category(category, section, applies_to_users_only) }
  end
  
end
