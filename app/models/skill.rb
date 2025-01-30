class Skill < ApplicationRecord
  has_many :users_skills, dependent: :destroy
  has_many :users, through: :users_skills
end
