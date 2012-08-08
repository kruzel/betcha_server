class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable,
  # :lockable, :timeoutable , :validatable 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
          :first_name, :family_name , :full_name, :is_app_installed, :gender, :locale, 
          :profile_pic_url, :provider, :uid, :access_token, :expires_at, :expires
  
  has_many :bets , :dependent => :destroy
  has_many :predictions , :dependent => :destroy
  has_many :chat_messages, :dependent => :destroy
  
  validates_uniqueness_of    :email,     :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of   :password, :on=>:create
  validates_confirmation_of   :password, :on=>:create
  validates_length_of :password, :within => Devise.password_length, :allow_blank => true
  
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
                          
        fb_utils = FacebookUtils.new(user,auth.credentials.token)
        success = fb_utils.get_facebook_info
        if success
          fb_utils.add_facebook_friends
        end
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
# == Schema Information
#
# Table name: users
#
#  id                     :integer(4)      not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer(4)      default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  authentication_token   :string(255)
#  first_name             :string(255)
#  family_name            :string(255)
#  full_name              :string(255)
#  is_app_installed       :boolean(1)
#  gender                 :integer(4)
#  locale                 :string(255)
#  profile_pic_url        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  access_token           :string(255)
#  expires_at             :datetime
#  expires                :boolean(1)
#  created_at             :datetime
#  updated_at             :datetime
#

