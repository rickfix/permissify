require 'spec_helper'

describe Permissify::Controller do

  describe 'allowed_to?' do
    before(:each) do
      @controller = PermissifiedControllerish.new
      Ability.reset
    end

    describe 'for an ability with a single applicability type' do
      before(:each) do
        Ability.add_category('something', 'a section', [Userish::PERMISSIFIED_ABILITY_APPLICABILITY], 'manage')
        @controller.should_receive(:current_entity).and_return(nil)
      end
      
      it 'should be false when controller-specified model method for applicability type returns nil' do
        @controller.should_receive(:current_user).and_return(nil)
        allowed_to_should be_false
      end
      
      describe 'and model method associated with applicability type returns a (permissified) model' do
        before(:each) do
          @user = Userish.new
          @controller.should_receive(:current_user).and_return(@user)
        end
      
        it 'should be true when model authorizes permission for ability' do
          category_action_permission_causes_allowed_to_be true, be_true
        end
        
        it 'should be false when model does not authorize permission for ability' do
          category_action_permission_causes_allowed_to_be false, be_false
        end
      end
    end

    # describe 'for an ability with a multiple applicability types' do
    # end
    
    def category_action_permission_causes_allowed_to_be(permission_true_or_false, be_true_or_false, action = :manage, category = :something)
      @user.should_receive(:permissions).and_return( {"#{category}_#{action}" => {'0' => permission_true_or_false} })
      allowed_to_should be_true_or_false, action, category
    end
    
    def allowed_to_should(be_true_or_false, action = :manage, category = :something)
      @controller.allowed_to?(:manage, :something).should be_true_or_false
    end
  end
end
