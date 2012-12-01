class ActivityEvent < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

end
