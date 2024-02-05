class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[create]

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: t(".success")
    else
      redirect_to root_path, danger: t(".fail")
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t(".success")
  end
end
