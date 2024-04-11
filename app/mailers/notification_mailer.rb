class NotificationMailer < ApplicationMailer
  default from: 'charilog.app@gmail.com'

  def upcoming_maintenance_notification(user, notification)
    @user = User.find(user.id)
    @maintenance_type = notification.notification_type_i18n
    @url = 'https://charilog.jp/notifications'
    mail(to: user.email, subject: '自転車メンテナンスのご案内')
  end
end
