module SystemFixtures::Abilities
  
  # required interface method : app Ability class must implement
  # - use Permissify::AbilityClass builder methods or *ml or whatever : just get @@abilities set
  def seed
    SPECIFY_ABILITIES_IN__APP__MODELS__SYSTEM_FIXTURES__ABILITIES

    # can organize permissions into categories that correspond to your client's/product team's view of app.
    # suggest playing with your Ability class and the builder methods in console.

    # Can define PERMISSIFIED_ABILITY_APPLICABILITY in any model
    # users_only = [Role::PERMISSIFIED_ABILITY_APPLICABILITY]
    # products_only  => [Product::PERMISSIFIED_ABILITY_APPLICABILITY]
    # products_and_roles  => users_only + products_only
    #
    # add_category('Tabs', 'Tabs', users_only, %w(Admin Dealers Corporations Brands Merchants))
    # { 'Roles'                 => 'Admin',
    #   'Products'              => 'Admin',
    #   'Admin Users'           => 'Admin',
    #   'Dealers'               => 'Dealer Admin',
    #   'Dealer Users'          => 'Dealer Admin',
    #   'Corporations'          => 'Corporation Admin',
    #   'Corporation Users'     => 'Corporation Admin',
    #   'Brands'                => 'Brand Admin',
    #   'Brand Users'           => 'Brand Admin',
    #   'Merchants'             => 'Merchant Admin',
    #   'Merchant Users'        => 'Merchant Admin',
    # }.each{ |category, section| add_category(category, section, users_only) }
    #
    # { 'Corporation Products'  => 'Corporation Admin',
    #   'Brand Products'        => 'Brand Admin',
    #   'Merchant Products'     => 'Merchant Admin',
    # }.each{ |category, section| add_category(category, section, users_only, %w(View Update)) }
    
    # add_category('Social Media', 'Social Media', products_and_roles, %w(Setup View Create Schedule Repeat))
    # add_category('Facebook', 'Social Media', products_and_roles, %w(Post Comment Like Remove))
    # add_category('Twitter', 'Social Media', products_and_roles, %w(Tweet Retweet Respond Remove))
    #
    #
    # [ 'Online Ordering',
    #   'Loyalty',
    #   'Webpage Builder',
    #   'eGift',
    #   'Guest Management',
    #   'Social Media 1',
    #   'Social Media 2',
    #   'Social Media 3',
    #   'Marketing Engine',
    #   'Social Marketing Engine',
    # ].each do |feature_bit|
    #   add_category(feature_bit, 'Solutions', products_only, %w(On))
    # end
    
  end
  
end
