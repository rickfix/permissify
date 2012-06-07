# NOTE : this could be an activerecord, does not need to be.
# - requires implementation of 'seed' interface method : see SystemFixtures::Abilities
class Ability
  
  class << self
    include Permissify::AbilityClass
    include SystemFixtures::Abilities
  end
  
end
