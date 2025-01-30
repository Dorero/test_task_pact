FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    patronymic { Faker::Name.middle_name }
    full_name { "#{surname} #{name} #{patronymic}" }
    email { Faker::Internet.email }
    age { rand(70) }
    nationality { Faker::Nation.nationality }
    country { Faker::Address.country }
    gender { rand(1) }

    trait :with_interests do
      after(:create) do |user|
        interests = create_list(:interest, 1)
        user.interests << interests
      end
    end

    trait :with_skills do
      after(:create) do |user|
        skills = create_list(:skil, 1)
        user.skills << skills
      end
    end
  end
end
