require 'spec_helper'

describe Permissify::Union do

  describe 'allowed_to?' do
    before(:each) { new_aggregate }

    it 'should return true when permission is set in a permissified model permission set' do
      (1..5).each{ |action| @a.allowed_to?(action.to_s, 'p').should be_true }
    end

    it 'should return false when permission is set to false in all permissified model permission sets where it is present or not present in any permission set' do
      (6..9).each{ |action| @a.allowed_to?(action.to_s, 'p').should be_false }
    end
  end
  
  [ %w(subscribed_to? product1_on   product1),
    %w(viewable?      thing_view    thing),
    %w(createable?    thing_create  thing),
    %w(updateable?    thing_update  thing),
    %w(deleteable?    thing_delete  thing),
  ].each do |method_name, permission_key, method_arg|
    describe "#{method_name}" do
      it "should be true when permission for '#{permission_key}' is specified as true" do
        method_should(be_true, {permission_key => {'0' => '1'}}, method_name, method_arg)
      end

      it "should be false when permission for '#{permission_key}' specified as false" do
        method_should(be_false, {permission_key => {'0' => '0'}}, method_name, method_arg)
      end

      it "should be false when permission for '#{permission_key}' not specified" do
        method_should(be_false, {}, method_name, method_arg)
      end
    
      def method_should(be_true_or_false, permissions, method_name, method_arg)
        new_aggregate( [new_permissified_model( permissions )] )
        @a.send(method_name, method_arg).should be_true_or_false
      end
    end
  end
    
  def new_aggregate(permissified_models = default_permissified_models)
    @a = Userish.new
    @pms = permissified_models
    @a.roles = @pms
  end
  
  def default_permissified_models
    [ new_permissified_model( {'p_1' => {'0' => '0'}, 'p_2' => {'0' => '1'}, 'p_3' => {'0' => '1'}, 'p_6' => {'0' => '0'}} ),
      new_permissified_model( {'p_1' => {'0' => '1'}, 'p_2' => {'0' => '0'}, 'p_4' => {'0' => '1'}, 'p_7' => {'0' => '0'}} ),
      new_permissified_model( {'p_1' => {'0' => '0'}, 'p_2' => {'0' => '0'}, 'p_5' => {'0' => '1'}, 'p_8' => {'0' => '0'}} )
    ]
  end
  
  def new_permissified_model(permissions)
    pm = PermissifiedModel.new
    pm.permissions = permissions
    pm
  end
end
