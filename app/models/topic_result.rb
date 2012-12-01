class TopicResult < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  belongs_to :topic
  belongs_to :prediction_option
end
