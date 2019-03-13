class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :address
  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments

  enum frequency: [:weekly, :biweekly, :monthly]
  enum status: [:active, :paused, :cancelled, :pending_payment]
  after_initialize :set_default_frequency, :if => :new_record?
  after_initialize :set_default_status, :if => :new_record?

  def set_default_frequency
    self.frequency ||= :biweekly
  end

  def set_default_status
    self.status ||= :pending_payment
  end
end
