class Users::ProfileUpdatesController < ApplicationController
  before_action :authenticate_user!

  # GET /users/edit_picture
  def edit_picture
    @user = current_user
  end

  # PATCH /users/update_picture
  def update_picture
    @user = current_user

    if @user.update_with_password(picture_params)
      bypass_sign_in(@user)
      redirect_to profile_index_path, notice: 'Profile picture updated successfully!'
    else
      render :edit_picture, status: :unprocessable_entity
    end
  end

  # GET /users/edit_information
  def edit_information
    @user = current_user
  end

  # PATCH /users/update_information
  def update_information
    @user = current_user

    if @user.update_with_password(information_params)
      bypass_sign_in(@user)
      redirect_to profile_index_path, notice: 'Personal information updated successfully!'
    else
      render :edit_information, status: :unprocessable_entity
    end
  end

  # GET /users/edit_password
  def edit_password
    @user = current_user
  end

  # PATCH /users/update_password
  def update_password
    @user = current_user

    if @user.update_with_password(password_params)
      bypass_sign_in(@user)
      redirect_to profile_index_path, notice: 'Password changed successfully!'
    else
      render :edit_password, status: :unprocessable_entity
    end
  end

  private

  def picture_params
    params.require(:user).permit(:photo, :current_password)
  end

  def information_params
    params.require(:user).permit(:name, :email, :current_password)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
