class Season < ActiveRecord::Base
  belongs_to(:show)
  has_many(:episode)
end
