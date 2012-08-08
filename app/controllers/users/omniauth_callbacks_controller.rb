class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    
    @user.email = request.env["omniauth.auth"]["info"]["email"]
    @user.full_name = request.env["omniauth.auth"]["info"]["name"]
    @user.provider = "facebook"
    @user.uid = request.env["omniauth.auth"]["uid"]
    @user.expires_at = Time.at(request.env["omniauth.auth"]["credentials"]["expires_at"]).to_datetime
    @user.expires = request.env["omniauth.auth"]["credentials"]["expires"]
    @user.gender = request.env["omniauth.auth"]["extra"]["gender"]
    @user.locale = request.env["omniauth.auth"]["extra"]["locale"]
    @user.profile_pic_url = request.env["omniauth.auth"]["info"]["image"]

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end