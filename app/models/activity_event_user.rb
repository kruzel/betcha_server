class ActivityEventUser < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  belongs_to :user
  belongs_to :activity_event

end
