class Address < ApplicationRecord
  belongs_to :user

  validates :address1, presence: true
  validates :city, presence: true
  validates :zip_code, presence: true
end
