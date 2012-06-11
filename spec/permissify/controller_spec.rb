require 'spec_helper'

describe Permissify::Controller do
  before(:each) { @controller = PermissifiedController.new }
  
  describe 'allowed_to?' do
    describe 'and no current entity' do
      before(:each) { @controller.should_receive(:current_entity).and_return(nil) }

      it 'should return false when no current user' do
        @controller.should_receive(:current_user).and_return(nil)
        allowed_to_should be_false
      end
      
      describe 'and current user is not nil' do
        before(:each) do
          @user = Userish.new
          @controller.should_receive(:current_user).and_return(@user)
        end

        it 'should return true when current user has permission for category action' do
          category_action_permission_causes_allowed_to_be true, be_true
        end
        
        it 'should return false when current user does not have permission for category action' do
          category_action_permission_causes_allowed_to_be false, be_false
        end
      end
    end
    
    describe 'and current entity exists' do
      describe 'and no current user' do
        it 'should return true when current entity has permission for category action' do
          pending('products phase')
        end
        
        it 'should return false when current entity does not have permission for category action' do
          pending('products phase')
        end
      end
      
      describe 'and current user is not nil' do
        describe 'and current entity has permission for category action' do
          it 'should return true when current user has permission for category action' do
            pending('products phase')
          end

          it 'should return false when current user does not have permission for category action' do
            pending('products phase')
          end
        end
        
        describe 'and current entity does not have permission for category action' do
          it 'should return false when current user has permission for category action' do
            pending('products phase')
          end

          it 'should return false when current user does not have permission for category action' do
            pending('products phase')
          end
        end
      end
    end

    def category_action_permission_causes_allowed_to_be(permission_true_or_false, be_true_or_false, action = :view, category = :something)
      @user.should_receive(:permissions_union).and_return( {"#{category}_#{action}" => {'0' => permission_true_or_false} })
      allowed_to_should be_true_or_false, action, category
    end
    
    def allowed_to_should(be_true_or_false, action = :view, category = :something)
      @controller.allowed_to?(:view, :something).should be_true_or_false
    end
  end
end
