class ApplicationController < ActionController::Base
  protect_from_forgery
  
  prepend_before_filter :get_api_key

  private
  def get_api_key
    if api_key = params[:api_key].blank? && request.headers["X-API-KEY"]
      params[:api_key] = api_key
    end
  end

  
  def after_sign_in_path_for(resource)
      return user_path(resource) || request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
end
