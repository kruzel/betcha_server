class Topic < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  belongs_to :topic_category
  belongs_to :location
  has_many :prediction_options, :dependent => :destroy
  has_one :topic_result
  has_many :bets
end
