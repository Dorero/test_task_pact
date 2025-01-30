require 'rails_helper'

RSpec.describe Users::CreateUser, type: :interaction do
  let(:valid_params) do
    {
      name: "Ivan",
      surname: "Petrov",
      patronymic: "Sergeevich",
      email: "ivan.petrov@example.com",
      age: 30,
      nationality: "Russian",
      country: "Russia",
      gender: "male",
      interests: [ "Sport", "Reading" ],
      skills: [ "Ruby", "Rails" ]
    }
  end

  before do
    create(:interest, name: "Sport")
    create(:interest, name: "Reading")
    create(:skill, name: "Ruby")
    create(:skill, name: "Rails")
  end

  context "when params is valid" do
    it "creates a user" do
      user = described_class.run(valid_params)
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "connects the user with interests" do
      user = described_class.run(valid_params)
      expect(user.result.interests.pluck(:name)).to match_array([ "Sport", "Reading" ])
    end

    it "connects the user with skills" do
      user = described_class.run(valid_params)
      expect(user.result.skills.pluck(:name)).to match_array([ "Ruby", "Rails" ])
    end
  end

  context "when params is not valid" do
    it "does not create a user without email" do
      params = valid_params.merge(email: nil)
      user = described_class.run(params)

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
      expect(user.errors.full_messages).to include("Email is required")
    end

    it "does not create a user if the email already exists" do
      create(:user, email: "ivan.petrov@example.com")
      user = described_class.run(valid_params)

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Email has already been taken")
    end

    it "does not create a user with age less than 0" do
      params = valid_params.merge(age: 0)
      user = described_class.run(params)

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Age must be in 1..90")
    end

    it "does not create a user with age grater than 90" do
      params = valid_params.merge(age: 91)
      user = described_class.run(params)

      expect(user).not_to be_valid
      expect(user.errors.full_messages).to include("Age must be in 1..90")
    end
  end
end
