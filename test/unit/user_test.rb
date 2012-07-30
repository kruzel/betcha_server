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

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
