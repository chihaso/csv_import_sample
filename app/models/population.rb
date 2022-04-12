class Population < ApplicationRecord
  belongs_to :municipality

  validates :year, :value, presence: true
  validates :year, numericality: { only_integer: true }, if: -> { year.present? }
  validates :value, numericality: { only_integer: true }, if: -> { value.present? }
end
