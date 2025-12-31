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

  def avatar_url(size: 150)
    return nil unless photo.attached?

	begin
		env_folder = Rails.env.to_s
		blob_key = self.photo.blob.key

		return Cloudinary::Utils.cloudinary_url(
			"#{env_folder}/#{blob_key}",
			transformation: [
				{ width: size,
				height: size,
				crop: :fill,
				gravity: :face }
			]
		)
	rescue => err 
		Rails.logger.error("Error generating avatar_url for user #{id}: #{err.message}")
		nil
	end
  end
end
