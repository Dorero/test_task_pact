class Interest < ApplicationRecord
  has_many :users_interests, dependent: :destroy
  has_many :users, through: :users_interests
end
