class Region < ApplicationRecord
  has_many :prefectures, dependent: :destroy
end
