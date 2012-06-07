require 'spec_helper'

describe Permissify::ModelClass do
  describe 'create_seeds' do
    it 'should locate, set permissions and save each specified seed' do
      (seed_specifications = [ [21, 'seeded model name1'], [81, 'seeded model name 2'] ]).each do |id, name|
        PermissifiedModel.should_receive(:locate).with(id, name).and_return(located_model = mock)
        app_implemented_permissions_method = "#{name.gsub(' ','_')}_permissions"
        PermissifiedModel.should_receive(app_implemented_permissions_method).and_return(:name_permissions)
        located_model.should_receive(:permissions=).with(:name_permissions)
        located_model.should_receive(:save)
      end
      PermissifiedModel.create_seeds seed_specifications
    end
  end
      
  describe 'create_with_id(table, id, name)' do
    it 'should create a new object, set its name, permissions, save it, force its id and then find it' do
      PermissifiedModel.should_receive(:name_permissions).and_return(:permissions_for_name)
      PermissifiedModel.should_receive(:new).and_return(mocked_permissions_model = mock())
      mocked_permissions_model.should_receive(:name=).with(:name)
      mocked_permissions_model.should_receive(:permissions=).with(:permissions_for_name)
      mocked_permissions_model.should_receive(:save)
      PermissifiedModel.should_receive(:force_seed_id).with(:table, mocked_permissions_model, :id)
      PermissifiedModel.should_receive(:find).with(:id).and_return(:model_returned_from_find)
      PermissifiedModel.create_with_id(:table, :id, :name).should == :model_returned_from_find
    end
  end

  describe 'locate(id, name)' do
    it 'should return model corresponding to input id when model with id exists' do
      mock_find_by_id :model_from_find_by_id
      PermissifiedModel.locate(:input_model_id, :input_model_id_name).should == :model_from_find_by_id
    end
    
    it 'should return response from app-implemented "create_input_model_id_name"' do
      mock_find_by_id nil
      PermissifiedModel.should_receive(:create_input_model_id_name).and_return(:model_from_create_input_model_id_name)
      PermissifiedModel.locate(:input_model_id, :input_model_id_name).should == :model_from_create_input_model_id_name
    end
    
    def mock_find_by_id(mocked_return)
      PermissifiedModel.should_receive(:find_by_id).with(:input_model_id).and_return(mocked_return)
    end
  end
  
  describe 'underscored_name_symbol(name)' do
    it 'should return a string' do
      PermissifiedModel.underscored_name_symbol(:symbol).class.name.should == 'String'
    end
    
    it 'should return a downcased version of input' do
      PermissifiedModel.underscored_name_symbol(:SYMBOL).should == 'symbol'
    end
    
    it 'should squish whitespace into a single underscore' do
      PermissifiedModel.underscored_name_symbol('   squish     it  ').should == '_squish_it_'
    end
    
    it 'should convert dashes to underscores' do
      PermissifiedModel.underscored_name_symbol('-dash--to---underscore----').should == '_dash_to_underscore_'
    end
    
    it 'should remove colons' do
      PermissifiedModel.underscored_name_symbol(':colons:::be:gone:::').should == 'colonsbegone'
    end
  end
end
