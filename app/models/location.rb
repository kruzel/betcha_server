class Location < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  has_many :topics
end
