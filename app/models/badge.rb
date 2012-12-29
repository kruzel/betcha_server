class Badge < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  def image_url
    ::Rails.application.config.server_url + badge_type.image.url(:thumb)
  end

  belongs_to :user
  belongs_to :badge_type
end
