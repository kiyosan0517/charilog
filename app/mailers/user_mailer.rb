class UserMailer < ApplicationMailer
  default from: 'charilog.app@gmail.com'

  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: 'メール・パスワード再設定のご案内')
  end
end
