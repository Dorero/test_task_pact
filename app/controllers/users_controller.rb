class UsersController < ApplicationController
  def create
    user = Users::CreateUser.run(user_params)

    if user.valid?
      render json: { user: user.result }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :surname, :patronymic, :email, :age,
      :nationality, :country, :gender,
      interests: [], skills: []
    )
  end
end
