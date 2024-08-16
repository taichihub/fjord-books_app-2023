# frozen_string_literal: true

class User < ApplicationRecord
  PROFILE_IMAGE_EXTENSIONS = %w[image/jpg image/png image/gif].freeze
  MAX_PROFILE_IMAGE_SIZE = 15.megabytes
  RESUZE_IMAGE_SIZE = [800, 800].freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  after_save :resize_large_image
  validates :profile_image, content_type: { in: PROFILE_IMAGE_EXTENSIONS, message: I18n.t('.activerecord.errors.messages.content_type_invalid') },
                            size: { less_than: MAX_PROFILE_IMAGE_SIZE, message: I18n.t('.activerecord.errors.messages.size_invalid') }

  private

  def resize_large_image
    return unless profile_image.attached? && profile_image.blob.byte_size > MAX_PROFILE_IMAGE_SIZE

    resized_image = ImageProcessing::MiniMagick
                    .source(profile_image.download)
                    .resize_to_limit(*RESUZE_IMAGE_SIZE)
                    .call
    profile_image.attach(io: File.open(resized_image.path), filename: profile_image.filename, content_type: profile_image.content_type)
  end
end
