require 'spec_helper'

describe Permissify::AbilityClass do
  describe 'all' do
    describe 'and interface seed not implemented' do
      it 'should raise NameError' do
        expect{NoSeedAbility.all}.to raise_error(NameError)
      end
    end

    describe 'and interface seed implemented' do
      it 'should return the correct number of abilities' do
        (a = Ability.all).size.should == 29
        a.first.should == tab_admin_ability
      end
    end
  end
  
  describe 'get' do
    it 'should return ability that has input key' do
      Ability.get('tabs_admin').should == tab_admin_ability
    end
    
    it 'should be nil when no ability with input key exists' do
      Ability.get('nuh_uh').should be_nil
    end
  end
      
  describe 'abilities builder method' do
    before(:each) { Ability.reset }

    describe 'reset' do
      it 'should reset abilities' do
        Ability.current.should == []
      end
    end

    describe 'add_category' do
      it 'should establish correct ability expression for fully specified category and action' do
        add_category1_section1
        Ability.current.should == [{:section=>"section1", :category=>"category1", :action=>"view", :position=>1, :key=>"category1_view", :applicability=>["Role", "Product"].to_set, :category_allows=>:one_or_none, :administration_expression=>"", :number_of_values=>1, :default_values=>[false], :any_or_all => :all?}]
      end

      it 'should establish correct ability expression for category and action with defaulted values' do
        Ability.add_category('category2', 'section2', ['Role'])
        Ability.current.should == [ {:section=>"section2", :category=>"category2", :action=>"View",   :position=>1, :key=>"category2_view",   :applicability=>["Role"].to_set, :category_allows=>:multiple, :administration_expression=>"", :number_of_values=>1, :default_values=>[false], :any_or_all => :all?},
                                    {:section=>"section2", :category=>"category2", :action=>"Create", :position=>2, :key=>"category2_create", :applicability=>["Role"].to_set, :category_allows=>:multiple, :administration_expression=>"", :number_of_values=>1, :default_values=>[false], :any_or_all => :all?},
                                    {:section=>"section2", :category=>"category2", :action=>"Update", :position=>3, :key=>"category2_update", :applicability=>["Role"].to_set, :category_allows=>:multiple, :administration_expression=>"", :number_of_values=>1, :default_values=>[false], :any_or_all => :all?},
                                    {:section=>"section2", :category=>"category2", :action=>"Delete", :position=>4, :key=>"category2_delete", :applicability=>["Role"].to_set, :category_allows=>:multiple, :administration_expression=>"", :number_of_values=>1, :default_values=>[false], :any_or_all => :all?} ]
      end
    end
  end

  describe 'permission builder method' do

    describe 'create_permissions_hash' do
      before(:each) do
        Ability.reset;
        Ability.seed;
        @ability_key_set = Ability.current.collect{|a| a[:key]}.to_set
      end

      it 'should express each current ability when invoked with no arguments' do
        @ability_key_set.should == Ability.create_permissions_hash.keys.to_set
      end
      
      it 'should exclude respective permissions to create, update and delete when a view only category is specified' do
        expected_keys.should == Ability.create_permissions_hash(['roles']).keys.to_set
      end
      
      it 'should exclude permissions for all permissions keys that begin with string in input remove categories arg' do
        expected_keys('roles_view').should == Ability.create_permissions_hash([], ['ro']).keys.to_set
      end
      
      def expected_keys(other_excluded_key = nil, excluded_keys = %w(roles_create roles_update roles_delete))
        @ability_key_set - [other_excluded_key] - excluded_keys
      end
    end

    describe 'remove_permission' do
      before(:each) { Ability.reset }

      it 'should remove all keys in the permissions hash that start with the input prefix' do
        Ability.reset
        add_category1_section1 %w(view1 view2 bill)
        Ability.create_permissions_hash
        Ability.remove_permission('category1_view')
        Ability.current_permissions_hash.should == {"category1_bill"=>{"0"=>"1"}}
      end
    end
  end
  
  def add_category1_section1(actions = 'view')
    Ability.add_category('category1', 'section1', %w(Role Product), actions, :all?, :one_or_none)
  end

  def tab_admin_ability
    {:default_values=>[false], :applicability=>["Role"].to_set, :category=>"Tabs", :administration_expression=>"", :section=>"Tabs", :category_allows=>:multiple, :number_of_values=>1, :key=>"tabs_admin", :position=>1, :action=>"Admin", :any_or_all => :all?}
  end
end
