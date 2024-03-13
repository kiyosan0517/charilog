class Profile::AttachmentsController < ApplicationController
  def destroy
    user = User.find(params[:id])
    user.avatar.purge

    if ActiveStorage::Blob.exists?(filename: 'sample.png')
      sample_avatar = ActiveStorage::Blob.find_by(filename: 'sample.png')
      user.avatar.attach(sample_avatar)
    else
      user.avatar.attach(io: File.open(Rails.root.join('app/assets/images/sample.png')),
                         filename: 'sample.png',
                         content_type: 'image/png')
    end

    redirect_to edit_profile_path
  end
end
