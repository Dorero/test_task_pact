require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:valid_params) do
    {
      user: {
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
    }
  end

  before do
    create(:interest, name: "Sport")
    create(:interest, name: "Reading")
    create(:skill, name: "Ruby")
    create(:skill, name: "Rails")
  end

  describe "POST /users" do
    context "when params are valid" do
      it "creates a user and associates interests and skills" do
        post users_path, params: valid_params, as: :json

        expect(response).to have_http_status(:created)

        user = User.last
        expect(user.name).to eq("Ivan")
        expect(user.full_name).to eq("Petrov Ivan Sergeevich")
        expect(user.email).to eq("ivan.petrov@example.com")
        expect(user.interests.pluck(:name)).to match_array([ "Sport", "Reading" ])
        expect(user.skills.pluck(:name)).to match_array([ "Ruby", "Rails" ])
      end
    end

    context "when user already created" do
      before { post users_path, params: valid_params, as: :json }

      it "does not create a user if the email already exists" do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:email] = "ivan.petrov@example.com"

        post users_path, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email has already been taken")
      end
    end

    context "when params are invalid" do
      it "does not create a user without email" do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:email] = nil

        post users_path, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Email is required")
      end

    it "does not create a user with age less than 0" do
      invalid_params = valid_params.deep_dup
      invalid_params[:user][:age] = 0

      post users_path, params: invalid_params, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Age must be in 1..90")
    end

    it "does not create a user with age greater than 90" do
        invalid_params = valid_params.deep_dup
        invalid_params[:user][:age] = 91

        post users_path, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Age must be in 1..90")
      end
    end
  end
end
