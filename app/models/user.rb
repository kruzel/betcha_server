class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
          :first_name, :family_name , :full_name, :is_app_installed, :gender, :locale, 
          :profile_pic_url, :provider, :uid, :access_token, :expires_at, :expires
  
  has_many :bets , :dependent => :destroy
  has_many :predictions , :dependent => :destroy
  has_many :chat_messages, :dependent => :destroy
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(full_name:auth.info.name,
                          provider:auth.provider,
                          uid:auth.uid,
                          email:auth.info.email,
                          access_token: auth.credentials.token ,
                          expires_at: Time.at(auth.credentials.expires_at).to_datetime, 
                          expires: auth.credentials.expires,
                          password:Devise.friendly_token[0,20]
                          )
    end
    user
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
