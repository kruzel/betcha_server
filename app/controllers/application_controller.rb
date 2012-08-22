class ApplicationController < ActionController::Base
  protect_from_forgery
  
  prepend_before_filter :get_auth_token

  private
  def get_auth_token
    if auth_token = params[:auth_token].blank? && request.headers["X-AUTH-TOKEN"]
      params[:auth_token] = auth_token
    end
  end

  def after_sign_in_path_for(resource)
      return user_path(resource) || request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
end
