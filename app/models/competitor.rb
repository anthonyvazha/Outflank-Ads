class Competitor < ApplicationRecord
  belongs_to :brand
  has_many :ads
end
