module PermissifiedController # Interfaces : override/rewrite as needed for your app
  
  # controller-accessible methods that app has implemented to access models that have been permissified.
  PERMISSIFY = SPECIFY_PERMISSIFIED_MODEL_LIST_IN__APP__CONTROLLERS__PERMISSIFIED_CONTROLLER

  # PERMISSIFY =  { User::PERMISSIFIED_ABILITY_APPLICABILITY => :current_user,
  #                 Product::PERMISSIFIED_ABILITY_APPLICABILITY => :current_entity,
  #               }
  
end
