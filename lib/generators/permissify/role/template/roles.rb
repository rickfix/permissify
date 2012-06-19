module SystemFixtures::Roles
  SEEDED_ORDERED_ROLES  = ['super user', 'system admin', 'dealer admin', 'corporation admin', 'brand admin', 'merchant admin']
  # SEEDED_ORDERED_ROLES  = ['super user', 'system admin', 'operations agent', 'call center agent']
  SEED_SPECIFICATIONS   = (1..SEEDED_ORDERED_ROLES.length).zip(SEEDED_ORDERED_ROLES)

  def seeded?(role); role.id <= SEEDED_ORDERED_ROLES.length; end
  def seed
    create_seeds SEED_SPECIFICATIONS
    Role.find(1).manage_ids = [2,3,4,5,6]
    Role.find(2).manage_ids = [2,3,4,5,6]
    Role.find(3).manage_ids = [3,4,5,6]
    Role.find(4).manage_ids = [4,5,6]
    Role.find(5).manage_ids = [6]
    Role.find(6).manage_ids = [6]
  end
  
  def create_super_user;      create_with(1, 'Admin')     ; end
  def create_system_admin;    create_with(2, 'Admin')     ; end
  def create_dealer_admin;    create_with(3, 'Dealer')    ; end
  def create_corporation_admin; create_with(4, 'Corporation') ; end
  def create_brand_admin;     create_with(5, 'Brand')     ; end
  def create_merchant_admin;  create_with(6, 'Merchant')  ; end
  
  def create_with(id, domain_type)
    role = create_with_id(:role, id, SEED_SPECIFICATIONS.assoc(id)[1])
    role.domain_type = domain_type
    role.save
    role
  end
  
  def super_user_permissions
    Ability.create_permissions_hash
  end
  def system_admin_permissions
    Ability.create_permissions_hash %w(roles products)
  end
  def dealer_admin_permissions
    Ability.create_permissions_hash( [], %w(roles products admin))
    Ability.remove_permissions %w(tabs_admin dealers_create dealers_delete dealer_users_create dealer_users_delete)
  end
  
  def corporation_admin_permissions
    msa_permissions %w(corporations_create corporations_delete)
  end
  def brand_admin_permissions
    msa_permissions %w(corporation brands_create brands_delete)
    Ability.remove_permissions %w(tabs_corporations brand_products_update merchant_products_update)
  end
  def merchant_admin_permissions
    msa_permissions %w(corporation brand)
    Ability.remove_permissions %w(tabs_brands tabs_corporations merchant_products_update)
  end
  def msa_permissions(exclude_abilities)
    no_abilities = exclude_abilities + %w(admin roles products dealer)
    Ability.create_permissions_hash([], no_abilities)
    Ability.remove_permissions %w(tabs_admin tabs_dealers)
  end
end
