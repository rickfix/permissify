class Product < ActiveRecord::Base
  
  include Permissify::Model
  
  # TODO : see how much of the following stuff can be rolled into ModelClass :
  validates_presence_of   :name
  validates_uniqueness_of :name
  before_create           :initialize_permissions
  serialize               :permissions
  
  class << self
    include Permissify::ModelClass
    include SystemFixtures::Products # app needs to provide this logic/specification : see example at app/models/system_fixtures/products.rb
    PERMISSIFIED_ABILITY_APPLICABILITY = 'Product'
  end
  
end
