class Product < ApplicationRecord
  enum size: [:small, :medium, :large]
  after_initialize :set_default_size, :if => :new_record?

  def set_default_size
    self.size ||= :medium
  end
end
