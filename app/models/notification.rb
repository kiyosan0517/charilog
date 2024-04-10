class Notification < ApplicationRecord
  belongs_to :user

  enum notification_type: {
    air_pressure: 0,      # 空気圧関連の通知
    chain_oil: 1,         # チェーンオイル関連の通知
    frame_cleaning: 2      # 自転車フレーム清掃関連の通知
  }
end
