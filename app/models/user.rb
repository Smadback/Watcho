class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

  has_many(:entries)
  has_many(:news)
  has_many(:shows, through: :user_shows)
end
