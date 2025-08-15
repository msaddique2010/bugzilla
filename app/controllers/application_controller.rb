class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?      # This line calls the "configure_permitted_parameters" method only for devise controller
  include Pundit::Authorization      # Used to include pundit in all controllers

  # allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized    # This line will rise an unauthorized error by calling "user_not_authorized" method

  private

  def user_not_authorized
    flash[:alert] = "You're not authorized to perform this action."   # Gives an alert
    redirect_to(request.referrer || root_path)    # "request.referrer" gives you the URL of the previous page the user came from, And root_path will redirect you to home page
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])        # Used to add an extra field to devise form
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])       # Used to add extra field to devise edit form
  end
end
