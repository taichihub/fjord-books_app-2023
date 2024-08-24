# frozen_string_literal: true

class User < ApplicationRecord
  PROFILE_IMAGE_EXTENSIONS = %w[image/jpg image/png image/gif].freeze
  MAX_PROFILE_IMAGE_SIZE = 15.megabytes
  RESIZE_IMAGE_SIZE = [800, 800].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  validates :profile_image, content_type: { in: PROFILE_IMAGE_EXTENSIONS },
                            size: { less_than: MAX_PROFILE_IMAGE_SIZE }

  def resized_profile_image
    profile_image.variant(resize_to_limit: RESIZE_IMAGE_SIZE).processed
  end
end
