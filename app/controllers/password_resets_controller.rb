class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    @user&.deliver_reset_password_instructions!
    redirect_to root_path, success: t('defaults.message.send_email')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    return not_authenticated if @user.blank?

    update_user_password
  end

  private

  def update_user_password
    @user.email = params[:user][:email]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password(params[:user][:password])
      password_reset_success
    else
      password_reset_failure
    end
  end

  def password_reset_success
    logout if logged_in?
    redirect_to root_path, success: t('.success')
  end

  def password_reset_failure
    flash.now[:danger] = t('.fail')
    render :edit
  end
end
