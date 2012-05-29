# TODO : talk about how this could be an active record, but just needs to support a set of interfaces (all, all_for, others?)
class Ability
  class << self
    include SystemFixtures::Abilities
    @@abilities = []

    def all; seed if @@abilities.empty?; @@abilities; end
    
    def all_for(applicability_types)
      applicability_types = [applicability_types] if applicability_types.kind_of?(String)
      all.select{|a| (a[:applicability] & applicability_types) == applicability_types}
    end
    
    def create_permissions_hash(view_only_categories=[], remove_categories=[], applicability_types = 'Role')
      @@permissions = {}
      all_for(applicability_types).each{|permission| @@permissions[permission[:key]] = {'0' => '1'}}
      view_only_categories.each{|category| view_only(category)}
      remove_categories.each{|category| remove(category)}
      @@permissions
    end
    
    private
    def view_only(category); %w(create update delete).each{|action| @@permissions.delete("#{category}_#{action}")};  end
    def remove(permission_prefix); @@permissions.keys.each{|key| @@permissions.delete(key) if key.starts_with?(permission_prefix)}; end
    def add(key, category, section, action, applicability, number_of_values, position, default_values, admin_expression='', category_allows = :multiple)
      @@abilities <<  { :key => key, :category => category, :section => section, :action => action,
                        :applicability => applicability, :number_of_values => number_of_values, :position => position,
                        :default_values => default_values, :administration_expression => admin_expression, :category_allows => category_allows}
    end
  end
end
