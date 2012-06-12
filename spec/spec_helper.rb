require 'rubygems'
require 'bundler/setup'

require 'permissify'
require 'permissify/ability_class'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

class Ability
  class << self
    include Permissify::AbilityClass
    
    def seed
      add_category('Tabs', 'Tabs', ['Role'], %w(Admin Dealer Corporate Brand Merchant))
      { 'Roles'                 => 'Admin',
        'Admin Users'           => 'Admin',
        'Dealer Users'          => 'Dealer Admin',
        'Corporate Users'       => 'Corporate Admin',
        'Brand Users'           => 'Brand Admin',
        'Merchant Users'        => 'Merchant Admin',
      }.each{ |category, section| add_category(category, section, ['Role']) }
    end
  end
end

class NoSeedAbility
  class << self
    include Permissify::AbilityClass
  end
end

class PermissifiedModel
  include Permissify::Model
  attr_accessor :name, :permissions
  class << self
    include Permissify::ModelClass
  end
end

class Roleish < PermissifiedModel
  DOMAIN_TYPES = %w(Admin Dealer Corporate Brand Merchant)
  attr_accessor :domain_type
end

class Userish
  include Permissify::Union
  # PERMISSIFIED_ABILITY_APPLICABILITY = 'Role'
  PERMISSIFIED_ASSOCIATION = :roles
  attr_accessor :roles
end

class UserishWithRoles
  include Permissify::Roles
  # PERMISSIFIED_ABILITY_APPLICABILITY = 'Role'
  PERMISSIFIED_ASSOCIATION = :roles
  attr_accessor :roles
end

class PermissifiedController
  include Permissify::Controller
  PERMISSIFY = [:current_user, :current_entity]
end

class Entityish
  include Permissify::Union
  # PERMISSIFIED_ABILITY_APPLICABILITY = 'Product'
  PERMISSIFIED_ASSOCIATION = :products
  attr_accessor :products
end

