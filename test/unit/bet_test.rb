# == Schema Information
#
# Table full_name: bets
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  subject    :string(255)
#  reward     :string(255)
#  date       :date
#  due_date   :date
#  state      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class BetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
