class Prefecture < ApplicationRecord
  belongs_to :region
  has_many :municipalities, dependent: :destroy

  def population_as_of (year)
    municipalities.sum { |municipality| municipality.population_as_of(year) || 0}
  end
end
