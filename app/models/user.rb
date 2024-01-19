class User < ApplicationRecord
  authenticates_with_sorcery!
  before_create :default_image

  has_one_attached :avatar
  has_many :posts, dependent: :destroy

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :bio, length: { maximum: 160 }

  enum my_bike:{
    "--未選択(特にない)--":0, 
    ANCHOR（アンカー）:1,ARAYA（アラヤ）:2,ARGON（アルゴン）:3,AVEDIO（エヴァディオ）:4,BASSO（バッソ）:5,BH（ビーエイチ）:6,Bianchi（ビアンキ）:7,BMC（ビーエムシー）:8,BOMA（ボーマ）:9,BOTTECCHIA（ボッテキア）:10,BRIDGESTONE（ブリヂストン）:11,BROMPTON（ブロンプトン）:12,
    Cannondale（キャノンデール）:13,CANYON（キャニオン）:14,CARRERA（カレラ）:15,CEEPO（シーポ）:16,centurion（センチュリオン）:17,cervelo（サーベロ）:18,CHAPTER2（チャプター2）:19,cinelli（チネリ）:20,CIPOLLINI（チッポリーニ）:21,COLNAGO（コルナゴ）:22,commencal（コメンサル）:23,corratec（コラテック）:24,CUBE（キューブ）:25, 
    DAHON（ダホン）:26,DEROSA（デローザ）:27,EDDYMERCKX（エディメルクス）:28,FELT（フェルト）:29,FOCUS（フォーカス）:30,FUJI（フジ）:31,GIANT（ジャイアント）:32,GIOS（ジオス）:33,GT（ジーティー）:34,GUSTO（グスト）:35,
    KhodaaBloom（コーダーブルーム）:36,KHS（ケーエイチエス）:37,KOGA（コガ）:38,KONA（コナ）:39,KUOTA（クオータ）:40,KUWAHARA（クワハラ）:41,LAPIERRE（ラピエール）:42,Liv（リブ）:43,LOOK（ルック）:44,LOUISGARNEAU（ルイガノ）:45,
    MARIN（マリン）:46,MERIDA（メリダ）:47,MIYATA（ミヤタ）:48,NEILPRYDE（ニールプライド）:49,NESTO（ネスト）:50,ORBEA（オルベア）:51,Panasonic（パナソニック）:52,PINARELLO（ピナレロ）:53,RALEIGH（ラレー）:54,RIDLEY（リドレー）:55,RITCHEY（リッチー）:56,
    SCOTT（スコット）:57,SHIMANO（シマノ）:58,SPECIALIZED（スペシャライズド）:59,THOMPSON（トンプソン）:60,TIME（タイム）:61,TREK（トレック）:62,Wilier（ウィリエール）:63,YONEX（ヨネックス）:64
  }

  def default_image
    if !self.avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'sample.png')),
                         filename: 'sample.png', content_type: 'image/png')
    end
  end

  def own?(object)
    id == object.user_id
  end
end
