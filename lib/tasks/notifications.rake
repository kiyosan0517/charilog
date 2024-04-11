namespace :notifications do
  desc '各ユーザーの各点検項目の次回実施日をチェックして、[次回実施日(next_date) == 当日(today)]のユーザーにメール送信'
  task check_the_next_date: :environment do
    users = User.joins(:notifications)
            .where.not(notifications: { sent_at: nil })
            .distinct
            .includes(:notifications)

    users.each do |user|
      user.notifications.where.not(sent_at: nil).each do |notification|
        next_date = case notification.notification_type
                    when 'air_pressure'
                      notification.sent_at + 7.days
                    when 'chain_oil'
                      notification.sent_at + 31.days
                    when 'frame_cleaning'
                      notification.sent_at + 62.days
                    end

        if next_date.to_date == Date.today
          NotificationMailer.upcoming_maintenance_notification(user, notification).deliver_now
        end
      end
    end
  end
end
