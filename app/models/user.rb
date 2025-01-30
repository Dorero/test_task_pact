class User < ApplicationRecord
  # Не понял, что имелось ввиду про два способа исправления опечатки. Предположил, что речь о связях.
  # many-to-many отношение можно сделать без промежуточной модели с помощью has_and_belongs_to_many, но я предпочетаю использовать промежуточную модель.

  has_many :users_skills, dependent: :destroy
  has_many :skills, through: :users_skills

  has_many :users_interests, dependent: :destroy
  has_many :interests, through: :users_interests


  enum :gender, [ :female, :male  ]
end
