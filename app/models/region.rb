class Region < ApplicationRecord
  has_many :prefectures, dependent: :destroy

  def population_as_of (year)
    prefectures.sum { |prefecture| prefecture.population_as_of(year) || 0 }
  end
end
