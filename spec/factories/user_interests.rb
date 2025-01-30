FactoryBot.define do
  factory :user_interest do
    association :user
    association :interest
  end
end
