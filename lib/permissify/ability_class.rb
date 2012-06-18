module Permissify
  module AbilityClass
    
    @@abilities = []

    def reset
      @@abilities = []
    end
    
    def current
      @@abilities
    end
    
    def all
      seed if @@abilities.empty?
      current
    end
  
    def all_for(applicability_types)
      applicability_types = [applicability_types] if applicability_types.kind_of?(String)
      applicability_types = applicability_types.to_set
      all.select{|a| (a[:applicability] & applicability_types) == applicability_types}
    end

    def get(action, category)
      key = key_for(action, category)
      all.select{ |ability| ability[:key] == key }.first
    end
    
    def actions(category_prefix)
      all.collect{|a| a[:action] if a[:key].start_with?("#{key_token(category_prefix)}_")}.compact
    end
    
    def add(category, section, action, applicability, requires_any_or_all, number_of_values, position, default_values, admin_expression='', category_allows = :multiple)
      applicability = applicability.to_set
      @@abilities <<  { :key => key_for(action, category), :category => category, :section => section, :action => action,
                        :applicability => applicability, :number_of_values => number_of_values, :position => position,
                        :default_values => default_values, :administration_expression => admin_expression,
                        :category_allows => category_allows, :any_or_all => requires_any_or_all}
    end

    def add_category(category, section, applicability, actions = %w(View Create Update Delete), requires_any_or_all = :all?, category_allows = :multiple)
      actions = [actions] unless actions.kind_of?(Array)
      actions.collect do |action|
        add(category, section, action, applicability, requires_any_or_all, 1, actions.index(action)+1, [false], '', category_allows)
      end
    end
    
    def create_permissions_hash(view_only_categories=[], remove_categories=[], applicability_types = 'Role')
      @@permissions = {}
      all_for(applicability_types).each{|permission| @@permissions[permission[:key]] = {'0' => '1'}}
      view_only_categories.each{|category| view_only(category)}
      remove_categories.each{|category| remove_permission(category)}
      @@permissions
    end

    def remove_permission(key_prefix)
      @@permissions.keys.each{ |key| @@permissions.delete(key) if key.start_with?(key_prefix) }
      @@permissions
    end

    def remove_permissions(key_prefixes)
      key_prefixes.each{ |key_prefix| remove_permission(key_prefix) }
      @@permissions
    end
    
    def current_permissions_hash
      @@permissions
    end

    def key_for(action, category)
      "#{key_token(category)}_#{key_token(action)}"
    end
  
    private

    def key_token(token)
      token.to_s.downcase.gsub('-','_').gsub(':','').gsub('  ',' ').gsub(' ','_')
    end
    
    def view_only(category)
      %w(create update delete).each{|action| @@permissions.delete("#{category}_#{action}")}
    end
  end
end
