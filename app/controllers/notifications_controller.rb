class NotificationsController < ApplicationController
  def index
    @air_pressure_sent_at = find_notification_sent_at(:air_pressure)
    @air_pressure_next_date = @air_pressure_sent_at.present? ? @air_pressure_sent_at + 7.days : nil

    @chain_oil_sent_at = find_notification_sent_at(:chain_oil)
    @chain_oil_next_date = @chain_oil_sent_at.present? ? @chain_oil_sent_at + 31.days : nil

    @frame_cleaning_sent_at = find_notification_sent_at(:frame_cleaning)
    @frame_cleaning_next_date = @frame_cleaning_sent_at.present? ? @frame_cleaning_sent_at + 62.days : nil
  end

  def create
    existing_notification = current_user.notifications.find_by(notification_type: notification_params[:notification_type])

    if existing_notification
      existing_notification.destroy
    end

    @notification = current_user.notifications.build(notification_params)

    if @notification.save
      render json: { success: true, message: '日付を登録しました' }
    else
      render json: { success: false, message: '日付の登録に失敗しました' }, status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.permit(:notification_type, :sent_at)
  end

  def find_notification_sent_at(notification_type)
    notification = current_user.notifications.find_by(notification_type: notification_type)
    notification.present? ? notification.sent_at : nil
  end
end
