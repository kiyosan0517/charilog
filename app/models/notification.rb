class Notification < ApplicationRecord
  belongs_to :user

  enum notification_type: {
    air_pressure: 'air_pressure',      # 空気圧関連の通知
    chain_oil: 'chain_oil',         # チェーンオイル関連の通知
    frame_cleaning: 'frame_cleaning'      # 自転車フレーム清掃関連の通知
  }
end
