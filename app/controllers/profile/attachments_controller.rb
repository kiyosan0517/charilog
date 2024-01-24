class Profile::AttachmentsController < ApplicationController
  def destroy
    avatar = ActiveStorage::Attachment.find(params[:id])
  
    # Get user associated with the avatar
    user = avatar.record

    # Purge the current avatar
    avatar.purge

    # Attach 'sample.png' as a new avatar
    sample_avatar_path = Rails.root.join('app', 'assets', 'images', 'sample.png')
    user.avatar.attach(io: File.open(sample_avatar_path), filename: 'sample.png')

    redirect_to edit_profile_path
  end
end
