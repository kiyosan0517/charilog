class Profile::AttachmentsController < ApplicationController
  def destroy
    user = User.find(params[:id])
    user.avatar.purge

    sample_avatar = ActiveStorage::Blob.find_by(filename: 'sample.png')

    if sample_avatar
      user.avatar.attach(sample_avatar)
    else
      sample_avatar_path = Rails.root.join('app', 'assets', 'images', 'sample.png')
      user.avatar.attach(io: File.open(sample_avatar_path), filename: 'sample.png')
    end

    redirect_to edit_profile_path
  end
end
