class TopicCategory < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  has_attached_file :image, :styles => { :thumb => "80x80>" }

  has_many :topics
end
