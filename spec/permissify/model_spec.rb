require 'spec_helper'

describe Permissify::Model do
  describe 'establish_from_permissions_model' do
    it 'should set from_permissions_model to nil when from is nil' do
      from_permissions_model_should_be nil
    end

    it 'should set from_permissions_model to find response when from is set' do
      PermissifiedModel.should_receive(:find).with(:with_from_value).and_return(:find_response)
      from_permissions_model_should_be(:find_response, :with_from_value)
    end
    
    def from_permissions_model_should_be(expected_from_permissions_model, from_value = nil)
      new_model
      @pm.from = from_value
      @pm.establish_from_permissions_model
      @pm.from_permissions_model.should == expected_from_permissions_model
    end
  end
      
  describe 'initialize_permissions' do
    before(:each) { new_model }
    
    it 'should set permissions to empty hash when from is not set' do
      permissions_should_be({}, nil)
    end

    it 'should set permissions from model that can be found with from value' do
      other_permissions_model = mock(:permissions => :other_permissions)
      @pm.should_receive(:establish_from_permissions_model).and_return(other_permissions_model)
      permissions_should_be(:other_permissions, :with_from_value)
    end
    
    def permissions_should_be(expected_permissions, from_value = nil)
      @pm.from = from_value
      @pm.initialize_permissions
      @pm.permissions.should == expected_permissions
    end
  end

  describe 'allows?' do
    it 'should return false when ability key is not present in permissions' do
      expect_allows({}, be_false)
    end

    it 'should return false when ability key is present in permissions but does not have a value corresponding to key \'0\'' do
      expect_allows({'permission' => {'1' => 'notzero'}}, be_false)
    end

    [nil, 0, '0', 1].each do |value_that_evaluates_to_false|
      it "should return false when ability key is present in permissions, and value corresponding to key '0' is #{value_that_evaluates_to_false} (#{value_that_evaluates_to_false.class.name})" do
        expect_allows({'permission' => {'0' => value_that_evaluates_to_false}}, be_false)
      end
    end

    it "should return true when ability key is present in permissions, and value corresponding to key '0' is '1'" do
      expect_allows({'permission' => {'0' => '1'}}, be_true)
    end
    
    def expect_allows(permission_hash_value, be_true_or_false)
      new_model
      @pm.permissions = permission_hash_value
      @pm.allows?('permission').should be_true_or_false
    end
  end
  
  describe 'remove_permissions' do
    it 'should set permissions value associated with input key(s) to nil' do
      new_model
      @pm.permissions = {:key1 => 1, :key2 => 1}
      @pm.should_receive(:save)
      @pm.remove_permissions(:key1)
      @pm.permissions.should == {:key1 => nil, :key2 => 1}
    end
  end
  
  describe 'update_permissions' do
    before(:each) { new_model }
    it 'should save merged permissions' do
      @pm.should_receive(:permissions).and_return(current_permissions = {})
      current_permissions.should_receive(:merge).with(:new_permissions).and_return(:merged_permissions)
      @pm.should_receive(:permissions=).with(:merged_permissions)
      @pm.should_receive(:save)
      @pm.update_permissions(:new_permissions)
    end
  end
  
  describe 'underscored_name_symbol' do
    before(:each) { new_model }
    
    it 'should invoke class underscored_name_symbol method with model name' do
      PermissifiedModel.should_receive(:underscored_name_symbol).with(@pm.name).and_return(:response_from_class_underscored_name_symbol_method)
      @pm.underscored_name_symbol.should == :response_from_class_underscored_name_symbol_method
    end
  end
  
  def new_model
    @pm = PermissifiedModel.new
    @pm.name = 'model name'
  end
end
