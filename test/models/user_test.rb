require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_user_creation_successful
    user = User.new
    assert user.save
  end
end
