module SystemFixtures::Products
  SEED_SPECIFICATIONS = [
    [1,   'Basic Service'],
    [2,   'Online Ordering'],
    [3,   'Loyalty'],
    [4,   'Webpage Builder'],
    [5,   'eGift'],
    [6,   'Guest Management'],
    [7,   'Marketing Engine'],
    [8,   'Social Media 1'],
    [9,   'Social Media 2'],
    [10,  'Social Media 3'],
    [11,  'Social Marketing Engine'],
  ]
  
  def seeded?(product); product.id <= SEED_SPECIFICATIONS.count; end
  def seed; create_seeds SEED_SPECIFICATIONS; end
  
  def create_basic_service;           create_with 1; end
  def create_online_ordering;         create_with 2; end
  def create_loyalty;                 create_with 3; end
  def create_webpage_builder;         create_with 4; end
  def create_egift;                   create_with 5; end
  def create_guest_management;        create_with 6; end
  def create_marketing_engine;        create_with 7; end
  def create_social_media_1;          create_with 8; end
  def create_social_media_2;          create_with 9; end
  def create_social_media_3;          create_with 10; end
  def create_social_marketing_engine; create_with 11; end
  def create_with(id); create_with_id(:product, id, SEED_SPECIFICATIONS.assoc(id)[1]); end

  def basic_service_permissions
    ph :basic_service_on
  end
  def online_ordering_permissions; ph :online_ordering_on; end
  def loyalty_permissions; ph :loyalty_on; end
  def webpage_builder_permissions; ph :webpage_builder_on; end
  def egift_permissions; ph :egift_on; end
  def guest_management_permissions; ph :guest_management_on; end
  def marketing_engine_permissions; ph :marketing_engine_on; end

  def social_media_1_permissions
    permissions = Ability.create_permissions_hash([], %w(social_media facebook twitter), %w(Product Role))
    permissions['social_media_setup'] = {'0' => '1'}
    permissions['social_media_view'] = {'0' => '1'}
    permissions
  end
  def social_media_2_permissions
    permissions = social_media_1_permissions
    permissions['social_media_create'] = {'0' => '1'}
    permissions['facebook_post'] = {'0' => '1'}
    permissions['twitter_tweet'] = {'0' => '1'}
    permissions
  end
  def social_media_3_permissions
    Ability.create_permissions_hash([], %w(social_media_repeat), %w(Product Role))
  end
  def social_marketing_engine_permissions
    permissions = social_media_3_permissions
    permissions['marketing_engine_on'] = {'0' => '1'}
    permissions['social_media_repeat'] = {'0' => '1'}
    permissions
  end
  
  def ph(permissions)
    permissions_hash = {}
    permissions = [permissions] unless permissions.kind_of?(Array)
    permissions.each{|p| permissions_hash[p.to_s] = {"0"=>"1"}}
    permissions_hash
  end
end
