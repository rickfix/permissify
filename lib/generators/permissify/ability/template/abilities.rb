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
    # add_category('Tabs', 'Tabs', applies_to_users_only, %w(Admin Dealers Corporations Brands Merchants))
    # { 'Roles'                 => 'Admin',
    #   'Admin Users'           => 'Admin',
    #   'Dealers'               => 'Dealer Admin',
    #   'Dealer Users'          => 'Dealer Admin',
    #   'Corporation Users'     => 'Corporation Admin',
    #   'Corporations'          => 'Corporation Admin',
    #   'Brand Users'           => 'Brand Admin',
    #   'Brands'                => 'Brand Admin',
    #   'Merchant Users'        => 'Merchant Admin',
    #   'Merchants'             => 'Merchant Admin',
    # }.each{ |category, section| add_category(category, section, applies_to_users_only) }
  end
  
end
