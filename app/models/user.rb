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
    "---":0, 
    ANCHOR:1,ARAYA:2,ARGON:3,Avedio:4,BASSO:5,BH:6,Bianchi:7,BMC:8,BOMA:9,BOTTECCHIA:10,BRIDGESTONE:11,BROMPTON:12,
    Cannondale:13,CANYON:14,CARRERA:15,CEEPO:16,centurion:17,cervelo:18,CHAPTER2:19,cinelli:20,CIPOLLINI:21,COLNAGO:22,commencal:23,corratec:24,CUBE:25, 
    DAHON:26,DEROSA:27,EDDYMERCKX:28,FELT:29,FOCUS:30,FUJI:31,GIANT:32,GIOS:33,GT:34,GUSTO:35,
    KhodaaBloom:36,KHS:37,KOGA:38,KONA:39,KUOTA:40,KUWAHARA:41,LAPIERRE:42,Liv:43,LOOK:44,LOUISGARNEAU:45,
    MARIN:46,MERIDA:47,MIYATA:48,NEILPRYDE:49,NESTO:50,ORBEA:51,Panasonic:52,PINARELLO:53,RALEIGH:54,RIDLEY:55,RITCHEY:56,
    SCOTT:57,SHIMANO:58,SPECIALIZED:59,THOMPSON:60,TIME:61,TREK:62,Wilier:63,YONEX:64
  }

  def default_image
    if !self.avatar.attached?
      self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'sample.png')), filename: 'sample.png', content_type: 'image/png')
    end
  end

  def own?(object)
    id == object.user_id
  end

end
