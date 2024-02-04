class Profile::AttachmentsController < ApplicationController
  def destroy
    avatar = ActiveStorage::Attachment.find(params[:id])
    user = avatar.record
    avatar.purge

    sample_avatar_path = Rails.root.join('app', 'assets', 'images', 'sample.png')
    user.avatar.attach(io: File.open(sample_avatar_path), filename: 'sample.png')

    redirect_to edit_profile_path
  end
end
