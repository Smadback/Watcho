class Show < ActiveRecord::Base
  has_many(:season)
  has_many(:users, through: :users_shows)
end
