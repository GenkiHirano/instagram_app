class User < ApplicationRecord

  validates :name, presence: true
  #validates :email, presence: true


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable

   def self.from_omniauth(auth)
     where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
       user.provider = auth.provider
       user.uid =      auth.uid
       user.name =     auth.name
       user.email =    auth.info.email
       user.password = Devise.friendly_token[0, 20] # ランダムなパスワードを作成
       user.image =    auth.info.image.gsub("picture","picture?type=large") if user.provider == "facebook"
     end
   end
end
