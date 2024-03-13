class Profile::AttachmentsController < ApplicationController
  def destroy
    user = User.find(params[:id])
    user.avatar.purge

    if ActiveStorage::Blob.exists?(filename: 'sample.png')
      sample_avatar = ActiveStorage::Blob.find_by(filename: 'sample.png')
      user.avatar.attach(sample_avatar)
    else
      sample_avatar_path = asset_path('sample.png')
      user.avatar.attach(sample_avatar_path)
    end

    redirect_to edit_profile_path
  end
end
