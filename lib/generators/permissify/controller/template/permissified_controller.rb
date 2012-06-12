module PermissifiedController # Interfaces : override/rewrite as needed for your app
  
  # controller-accessible methods that app has implemented to access models that have been permissified.
  PERMISSIFY = SPECIFY_PERMISSIFIED_MODEL_LIST_IN__APP__CONTROLLERS__PERMISSIFIED_CONTROLLER
  # PERMISSIFY =  [ [:current_user,   User::PERMISSIFIED_ABILITY_APPLICABILITY],
  #                 [:current_entity, 'Product'], # Entityish::PERMISSIFIED_ABILITY_APPLICABILITY],
  #               ]

  # * does order matter?  don't think so...
  # * check case for public webpages? does it unwind?

end
