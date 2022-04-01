class Municipality < ApplicationRecord
  belongs_to :prefecture
  has_many :populations, dependent: :destroy
end
