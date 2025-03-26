class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = user.generate_jwt
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)
    if user.save
      token = user.generate_jwt
      render json: { token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :image)
  end
end
