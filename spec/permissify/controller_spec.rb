require 'spec_helper'

describe Permissify::Controller do

  describe 'allowed_to?' do
    before(:each) do
      @controller = PermissifiedControllerish.new # controller specifies multiple permissified_model_method/ability applicability pairs
    end

    describe 'for an ability with a single applicability type, ' do
      before(:each) do
        @applicability = [Userish::PERMISSIFIED_ABILITY_APPLICABILITY]
        add_ability :all?
      end
      
      it 'should be false when controller-specified model method for applicability type returns nil' do
        @controller.should_receive(:current_user).and_return(nil)
        allowed_to_should be_false
      end
      
      describe 'and the model method associated with applicability type returns a (permissified) model, ' do
        before(:each) { current_user_exists }
      
        it 'should be true when model authorizes permission for ability' do
          category_action_permission_causes_allowed_to_be true, be_true
        end
        
        it 'should be false when model does not authorize permission for ability' do
          category_action_permission_causes_allowed_to_be false, be_false
        end
      end
    end
    
    describe 'for an ability with multiple applicability types, ' do
      before(:each) do
        current_user_exists
        @applicability = [Entityish::PERMISSIFIED_ABILITY_APPLICABILITY, Userish::PERMISSIFIED_ABILITY_APPLICABILITY]
      end

      describe 'and ability requires all, ' do
        before(:each) { add_ability(:all?) }

        it 'should be false when any applicable model permission method returns nil' do
          @controller.should_receive(:current_entity).and_return(nil)
          category_action_permission_causes_allowed_to_be false, be_false
        end

        describe 'and all applicable model permission methods return a (permissified) model' do
          before(:each) do
            @entity = Entityish.new
            @controller.should_receive(:current_entity).and_return(@entity)
            @entity.should_receive(:permissions).and_return( {"something_manage" => {'0' => true} })
          end
          
          it 'should be false when any applicable permissified model does not have permission for the ability' do
            category_action_permission_causes_allowed_to_be false, be_false
          end
        
          it 'should be true when all applicable permissified models have permission for the ability' do
            category_action_permission_causes_allowed_to_be true, be_true
          end
        end
      end
      
      describe 'and ability requires any' do
        before(:each) { add_ability(:any?) ; @controller.should_receive(:current_entity).and_return(nil) }

        it 'should be true when any applicable permissified model has permission for the ability' do
          category_action_permission_causes_allowed_to_be true, be_true, :log_permissions
        end

        it 'should be false when no applicable permissified model has permission for the ability' do
          category_action_permission_causes_allowed_to_be false, be_false, :log_permissions
        end
      end
    end

    def add_ability(requires_any_or_all)
      Ability.reset
      Ability.add_category('something', 'a section', @applicability, 'manage', requires_any_or_all)
    end
    
    def category_action_permission_causes_allowed_to_be(permission_true_or_false, be_true_or_false, log_option = :none, action = :manage, category = :something)
      @user.should_receive(:permissions).and_return( {"#{category}_#{action}" => {'0' => permission_true_or_false} })
      allowed_to_should be_true_or_false, action, category
      @controller.log_permissions if log_option == :log_permissions
    end
    
    def allowed_to_should(be_true_or_false, action = :manage, category = :something)
      @controller.allowed_to?(:manage, :something).should be_true_or_false
    end

    def current_user_exists
      @user = Userish.new
      @controller.should_receive(:current_user).and_return(@user)
    end

  end
end
