class User < ActiveRecord::Base
  belongs_to :role
  belongs_to :faculty
  has_many :operations

  before_create :create_remember_token

  validates :surname, presence: true, length: { maximum: 50 }

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
