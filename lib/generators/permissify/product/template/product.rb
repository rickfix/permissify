class Product < ActiveRecord::Base
  validates_presence_of   :name
  validates_uniqueness_of :name
  before_create :initialize_permissions
  serialize :permissions
  include Permissify::Model
  # is_paranoid
  default_scope :conditions => {:deleted_at => nil}, :order => "products.name"
  
  class << self
    include Permissify::ModelClass
    include SystemFixtures::Products

    # TODO : this stuff should be plugged in by app
    def revenuepwr;               locate(1, 'revenuePWR'); end
    def integrated_reservations;  locate(3, 'Integrated Reservations'); end
    def pos_integration;          locate(3, 'POS Integration'); end
    def standalone_reservations;  locate(4, 'Standalone Reservations'); end
    def online_ordering;          locate(5, 'Online Ordering'); end
    def loyalty;                  locate(6, 'Loyalty'); end
    def webpage_builder;          locate(7, 'Webpage Builder'); end
    def egift;                    locate(8, 'eGift'); end
    def guest_management;         locate(12, 'Guest Management'); end
    def mobile_marketing;         locate(13, 'Mobile Marketing'); end
    def offers_and_incentives;    locate(14, 'Offers & Incentives'); end
    def revenuepwr_lite;          locate(15, 'revenuePWR Lite'); end
    def waitlist;                 locate(16, 'Waitlist'); end
    def consumer_driven_deals;    locate(17, 'Consumer-Driven Deals'); end    
  end
end