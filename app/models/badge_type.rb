class BadgeType < ActiveRecord::Base
  include Uuid
  before_create :gen_uid

  has_attached_file :image, :styles => { :thumb => "80x80>" }

  def image_url
    ::Rails.application.config.server_url + image.url(:thumb)
  end

  has_many :badges

end
