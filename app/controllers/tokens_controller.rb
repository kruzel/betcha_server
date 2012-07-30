class TokensController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create_oauth
    full_name = params[:full_name]
    email = params[:email]
    provider = params[:provider]
    uid = params[:uid]
    token = params[:token]
    expires_at = params[:expires_at]
    expires = params[:expires]
    
    user = User.find_by_uid(uid)
    
    success = true
    
    unless user
      user = User.create(full_name: full_name,
                          provider: provider,
                          uid: uid,
                          email: email,
                          access_token: token ,
                          expires_at: Time.at(expires_at).to_datetime, 
                          expires: expires,
                          password: Devise.friendly_token[0,20]
                          )
      unless user
        success = false
      end
    else 
      user.full_name = full_name unless full_name.nil?
      user.email = email unless email.nil?
      user.provider = provider unless provider.nil?
      user.uid = uid unless uid.nil?
      user.access_token = token unless token.nil?
      user.expires_at = expires_at unless expires_at.nil?
      user.expires = expires unless expires.nil?
      user.ensure_authentication_token
      unless user.save
        success = false
      end
    end
    
    #TODO add FB friends to friends table
    #
    #    fbUser = FbGraph::User.me(token)
    #    fbUser = fbUser.fetch
    #    user = User.find_by_uid(fbUser.identifier)

    if not success
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"sign in failed."}
    else
      render :status=>200, :json=>{:token=>user.authentication_token, :id=>user.id}
    end
  end

  
  def create
    email = params[:email]
    password = params[:password]
    full_name = params[:full_name]
    
    
    if request.format != :json
        render :status=>406, :json=>{:message=>"The request must be json"}
        return
    end
    
    if email.nil? or password.nil?
      render :status=>400, :json=>{:message=>"The request must contain the user email and password."}
      return
    end
        
    user=User.find_by_email(email.downcase)
    
    success = true
    if user.nil?
      logger.info("User #{email} signin, user cannot be found. creating new")
      user = User.new()
      user.full_name = full_name
      user.email = email
      user.password = password
      user.ensure_authentication_token
      unless user.save
        success = false
      end
    else
      logger.info("User #{email} signin, user found. updating and creating token")
      if not full_name.nil?
        user.full_name = full_name
      end
      user.email = email
      if not user.valid_password?(password)
        logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
        render :status=>401, :json=>{:message=>"Invalid email or passoword."}
        return
      end

      user.password = password
      user.ensure_authentication_token
      unless user.save
        success = false
      end
    end
        
    if not success
      logger.info("User #{email} failed signin, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"sign in failed."}
    else
      render :status=>200, :json=>{:token=>user.authentication_token, :id=>user.id}
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
