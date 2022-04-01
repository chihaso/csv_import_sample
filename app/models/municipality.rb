class Municipality < ApplicationRecord
  belongs_to :prefecture
  has_many :populations, dependent: :destroy

  def population_as_of(year)
    populations.find { _1.year == year }&.value || nil
  end
end
