class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders

  # # validations
  # validates :username, presence: true, uniqueness: true

  def admin?
      self.role == "admin"
      # self is optional, but it makes it very clear that this is MY method, not one that was already here or came from somewhere else
  end

  def guest?
    self.role == "guest"
  end
end
