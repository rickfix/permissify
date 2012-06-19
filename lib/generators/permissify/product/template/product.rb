class Product < ActiveRecord::Base
  
  include Permissify::Model
  PERMISSIFIED_ABILITY_APPLICABILITY = 'Product'
  has_and_belongs_to_many :admins
  has_and_belongs_to_many :dealers
  has_and_belongs_to_many :corporations
  has_and_belongs_to_many :brands
  has_and_belongs_to_many :merchants
  
  # TODO : see how much of the following stuff can be rolled into ModelClass :
  validates_presence_of   :name
  validates_uniqueness_of :name
  before_create           :initialize_permissions
  serialize               :permissions
  
  class << self
    include Permissify::ModelClass
    include SystemFixtures::Products # app needs to provide this logic/specification : see example at app/models/system_fixtures/products.rb
  end
  
end
