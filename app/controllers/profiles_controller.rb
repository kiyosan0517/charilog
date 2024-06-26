class ProfilesController < ApplicationController
  before_action :set_profile, only: [:edit, :update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), success: t('defaults.message.updated', item: t('defaults.profile'))
    else
      flash.now[:danger] = t('defaults.message.not_updated', item: t('defaults.profile'))
      render :edit
    end
  end

  private

  def set_profile
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :my_bike, :bio, :avatar, :avatar_cache, :public)
  end
end
