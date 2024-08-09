# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :set_default_name, on: %i[create update]

  validates :name, presence: true
  validates :self_introduction, length: { maximum: 200 }

  private

  def set_default_name
    self.name ||= 'BooksAppUser'
  end
end
