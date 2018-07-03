class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_user!, unless: :switch_user_controller?

  def render_js_error(e)
    render js: "alert(`#{e}`)", status: :bad_request
  end

  protected

  def switch_user_controller?
    controller_name == 'switch_user'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
