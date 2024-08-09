# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update]
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.page(params[:page]).per(5)
  end

  def show; end

  def edit
    redirect_to user_path(current_user) unless @user == current_user
  end

  def update
    if @user.update(user_params)
      if email_or_password_changed?
        sign_out @user
        redirect_to new_user_session_path, notice: t('users.update.relogin')
      else
        redirect_to user_path(@user), notice: t('users.update.success')
      end
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :post_code, :address, :self_introduction)
  end

  def email_or_password_changed?
    @user.previous_changes.key?('email') || @user.previous_changes.key?('encrypted_password')
  end
end
