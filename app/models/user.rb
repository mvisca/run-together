class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  has_one_attached :photo
  has_many :runners, dependent: :destroy
  has_many :races, dependent: :destroy
  has_one :intro, dependent: :destroy
end
