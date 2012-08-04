class ChatMessage < ActiveRecord::Base
  belongs_to :bet
  belongs_to :user
end
# == Schema Information
#
# Table name: chat_messages
#
#  id                :integer(4)      not null, primary key
#  bet_id            :integer(4)
#  user_id           :integer(4)
#  type              :integer(4)
#  message           :string(255)
#  notification_sent :boolean(1)
#  created_at        :datetime
#  updated_at        :datetime
#

