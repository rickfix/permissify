module SystemFixtures::Roles
  SEEDED_ORDERED_ROLES  = ['super user', 'system admin', 'dealer admin', 'corporate admin', 'brand admin', 'merchant admin']
  # SEEDED_ORDERED_ROLES  = ['super user', 'system admin', 'operations agent', 'call center agent']
  SEED_SPECIFICATIONS   = (1..SEEDED_ORDERED_ROLES.length).zip(SEEDED_ORDERED_ROLES)

  def seeded?(role); role.id <= SEEDED_ORDERED_ROLES.length; end
  def seed; create_seeds :roles, SEED_SPECIFICATIONS; end
  
  def create_super_user;      create_with(1, SEEDED_ORDERED_ROLES,       'Admin')     ; end
  def create_system_admin;    create_with(2, SEEDED_ORDERED_ROLES[1..5], 'Admin')     ; end
  def create_dealer_admin;    create_with(3, SEEDED_ORDERED_ROLES[2..5], 'Dealer')    ; end
  def create_corporate_admin; create_with(4, SEEDED_ORDERED_ROLES[3..5], 'Corporate') ; end
  def create_brand_admin;     create_with(5, ['Merchant'], 'Brand')                   ; end
  def create_merchant_admin;  create_with(6, ['Merchant'], 'Merchant')                ; end
  
  def create_with(id, other_roles, domain_type)
    role = create_with_id(:role, id, SEED_SPECIFICATIONS.assoc(id)[1])
    role.can_manage_roles = other_roles
    role.domain_type = domain_type
    role.save
    role
  end
  
  def super_user_permissions
    @@permissions = Ability.create_permissions_hash
  end
  def system_admin_permissions
    @@permissions = Ability.create_permissions_hash 'roles'
  end
  def dealer_admin_permissions
    @@permissions = Ability.create_permissions_hash( [], %w(roles admin))
    remove %w(tabs_admin)
  end
  
  def corporate_admin_permissions
    msa_permissions %w(corporate_portal_create brand_portal_create)
  end
  def brand_admin_permissions
    msa_permissions %w(corporate brand_portal_create brand_portal_update)
    remove %w(tabs_corporate)
  end
  def merchant_admin_permissions
    msa_permissions %w(corporate brand)
    remove %w(tabs_brand tabs_corporate)
  end
  def msa_permissions(exclude_abilities)
    no_abilities = exclude_abilities + %w(admin roles dealer)
    @@permissions = Ability.create_permissions_hash([], no_abilities)
    remove %w(tabs_admin tabs_dealer)
  end

  def remove(permissions); permissions.each{|permission| @@permissions.delete(permission.to_s)}; @@permissions; end
end
