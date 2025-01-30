class Users::CreateUser < ActiveInteraction::Base
  string :name, :surname, :patronymic, :email, :nationality, :country, :gender
  integer :age
  array :interests, default: []
  array :skills, default: []

  validates :name, :surname, :patronymic, :email, :nationality, :country, :gender, presence: true
  validates :gender, inclusion: { in: %w[male female] }
  validates :age, numericality: { in: 1..90 }

  validate :email_uniqueness
  def execute
    user = User.new(
      name: name,
      surname: surname,
      patronymic: patronymic,
      full_name: "#{surname} #{name} #{patronymic}",
      email: email,
      age: age,
      nationality: nationality,
      country: country,
      gender: gender == "male" ? 1 : 0
    )

    if user.save
      assign_interests(user)
      assign_skills(user)
    else
      errors.merge!(user.errors)
    end

    user
  end

  private

  def assign_interests(user)
    interest_ids = Interest.where(name: interests).pluck(:id)
    users_interests = interest_ids.map { |interest_id| { user_id: user.id, interest_id: interest_id } }
    UsersInterest.insert_all(users_interests) if users_interests.any?
  end

  def assign_skills(user)
    skill_ids = Skill.where(name: skills).pluck(:id)
    users_skills = skill_ids.map { |skill_id| { user_id: user.id, skill_id: skill_id } }
    UsersSkill.insert_all(users_skills) if users_skills.any?
  end


  def email_uniqueness
    if User.exists?(email: email)
      errors.add(:email, "has already been taken")
    end
  end
end
