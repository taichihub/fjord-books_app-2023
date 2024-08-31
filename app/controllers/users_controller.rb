# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.order(created_at: :desc).page(params[:page]).per(5)
  end

  def show; end

  def edit
    redirect_to user_path(current_user) if @user != current_user
  end

  def update
    if @user == current_user
      if @user.update(user_params)
        redirect_to user_path(@user), notice: t('users.update.success')
      else
        render :edit, status: :unprocessable_entity, alert: t('users.update.failure')
      end
    else
      redirect_to user_path(current_user)
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :post_code, :address, :self_introduction)
  end
end
