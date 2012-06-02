module SystemFixtures::Abilities
  def seed
    SPECIFY_ABILITIES_IN__APP__MODELS__SYSTEM_FIXTURES__ABILITIES
    # and remember to trigger in seed process by including in, for example, Ability.seed in your db/seed.rb file

    # # organize permissions into categories that correspond to your client's/product team's view of the system
    # add_category('Tabs', 'Tabs', ['Role'], %w(Admin Dealer Corporate Brand Merchant))
    # { 'Roles'                 => 'Admin',
    #   'Admin Users'           => 'Admin',
    #   'Dealer Users'          => 'Dealer Admin',
    #   'Corporate Users'       => 'Corporate Admin',
    #   'Brand Users'           => 'Brand Admin',
    #   'Merchant Users'        => 'Merchant Admin',
    # }.each{ |category, section| add_category(category, section) }
  end
end
