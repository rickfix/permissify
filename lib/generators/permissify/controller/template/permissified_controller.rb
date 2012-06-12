module PermissifiedController # Interfaces : override/rewrite as needed for your app
  
  # controller-accessible methods that app has implemented to access models that have been permissified.
  PERMISSIFY = SPECIFY_PERMISSIFIED_MODEL_LIST_IN_APP_CONTROLLERS_PERMISSIFIED_CONTROLLER
  # PERMISSIFY = [:current_user, :current_entity]

  # * does order matter?  don't think so...
  # * check case for public webpages? does it unwind?

end
