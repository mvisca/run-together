class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?

  # TODO: add new instance variables that will be required in de account creation.
  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    profile_index_path
  end

  def after_edit_path_for(resource_or_scope)
    new_race_path
  end
end
