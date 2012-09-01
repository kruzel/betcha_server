class TokensController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    success = true
    provider = params[:provider]
    
    if provider == "email"
      email = params[:email]
      password = params[:password]
      user = User.find_by_email(email)
      unless user
        logger.info("User #{email} not found")
        success = false
      else
        unless user.valid_password?(password)
          logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
          success = false
        end
      end
    else
      #facebook
      uid = params[:uid]
      access_token = params[:access_token]
      if !uid.nil?
        user = User.find_by_uid(uid)
      end
      if user.nil?
        user = User.find_by_access_token(access_token)
      end
      unless user
        logger.info("User #{uid} not found")
        success = false
      else
        unless access_token = user.access_token
          logger.info("User #{uid} failed signin, access_token \"#{access_token}\" is invalid")
          success = false
        end
      end
    end
    
    if success
      user.ensure_authentication_token
      unless user.save
        success = false
      end
    end

    if not success
      render :status=>401, :json=>{:message=>"sign in failed."}
    else
      render :status=>200, :json=>{:token=>user.authentication_token}
    end
  end
  
  def destroy
    user=User.find_by_authentication_token(params[:id])
    if user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end 
end
