class Prefecture < ApplicationRecord
  belongs_to :region
  has_many :municipalities, dependent: :destroy
end
