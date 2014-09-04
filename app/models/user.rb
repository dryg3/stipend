class User < ActiveRecord::Base
  has_many :users_roles
  has_many :roles, :through => :users_roles
  belongs_to :faculty
  has_many :operations

  before_create :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  has_secure_password
 # validates :password, length: { minimum: 6 }
  #has_secure_password


    def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
