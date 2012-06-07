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
      }.each{ |category, section| add_category(category, section) }
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
