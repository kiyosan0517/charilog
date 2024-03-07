class User < ApplicationRecord
  authenticates_with_sorcery!
  before_create :default_image

  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :followers, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :followeds, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy, inverse_of: :followed

  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX, message: 'が有効な形式ではありません' }
  validates :email, presence: true, uniqueness: { case_sensitive: true }
  validates :name, presence: true
  validates :bio, length: { maximum: 160 }
  validate :avatar_size

  enum my_bike: {
    ANCHOR（アンカー）: 0, ARAYA（アラヤ）: 1, ARGON（アルゴン）: 2, AVEDIO（エヴァディオ）: 3, BASSO（バッソ）: 4, BH（ビーエイチ）: 5, Bianchi（ビアンキ）: 6, BMC（ビーエムシー）: 7,
    BOMA（ボーマ）: 8, BOTTECCHIA（ボッテキア）: 9, BRIDGESTONE（ブリヂストン）: 10, BROMPTON（ブロンプトン）: 11, Cannondale（キャノンデール）: 12, CANYON（キャニオン）: 13,
    CARRERA（カレラ）: 14, CEEPO（シーポ）: 15, centurion（センチュリオン）: 16, cervelo（サーベロ）: 17, CHAPTER2（チャプター2）: 18, cinelli（チネリ）: 19, CIPOLLINI（チッポリーニ）: 20,
    COLNAGO（コルナゴ）: 21, commencal（コメンサル）: 22, corratec（コラテック）: 23, CUBE（キューブ）: 24, DAHON（ダホン）: 25, DEROSA（デローザ）: 26, EDDYMERCKX（エディメルクス）: 27,
    FELT（フェルト）: 28, FOCUS（フォーカス）: 29, FUJI（フジ）: 30, GIANT（ジャイアント）: 31, GIOS（ジオス）: 32, GT（ジーティー）: 33, GUSTO（グスト）: 34,
    KhodaaBloom（コーダーブルーム）: 35, KHS（ケーエイチエス）: 36, KOGA（コガ）: 37, KONA（コナ）: 38, KUOTA（クオータ）: 39, KUWAHARA（クワハラ）: 40, LAPIERRE（ラピエール）: 41,
    Liv（リブ）: 42, LOOK（ルック）: 43, LOUISGARNEAU（ルイガノ）: 44, MARIN（マリン）: 45, MERIDA（メリダ）: 46, MIYATA（ミヤタ）: 47, NEILPRYDE（ニールプライド）: 48, NESTO（ネスト）: 49,
    ORBEA（オルベア）: 50, Panasonic（パナソニック）: 51, PINARELLO（ピナレロ）: 52, RALEIGH（ラレー）: 53, RIDLEY（リドレー）: 54, RITCHEY（リッチー）: 55, SCOTT（スコット）: 56,
    SHIMANO（シマノ）: 57, SPECIALIZED（スペシャライズド）: 58, THOMPSON（トンプソン）: 59, TIME（タイム）: 60, TREK（トレック）: 61, Wilier（ウィリエール）: 62, YONEX（ヨネックス）: 63
  }

  def default_image
    return if avatar.attached?

    sample_avatar = ActiveStorage::Blob.find_by(filename: 'sample.png')

    if sample_avatar
      avatar.attach(sample_avatar)
    else
      avatar.attach(io: File.open(Rails.root.join('app/assets/images/sample.png')),
                    filename: 'sample.png',
                    content_type: 'image/png')
    end
  end

  def avatar_size
    return unless avatar.present? && (avatar.blob.byte_size > 5.megabytes)

    errors.add(:avatar, 'はサイズ5MB以内の画像にしてください')
  end

  def own?(object)
    id == object.user_id
  end

  def follow(user_id)
    followers.create(followed_id: user_id)
  end

  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def liked?(post)
    like_posts.include?(post)
  end

  def posts_all_like_count
    user_posts = posts.includes(:likes)
    posts_all_like_count = 0

    user_posts.each do |post|
      posts_all_like_count += post.likes.size
    end
    posts_all_like_count
  end
end
