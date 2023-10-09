class Ad < ApplicationRecord
    belongs_to :brand
    belongs_to :competitor, optional: true
    has_many :competitors
    has_many :ads
  end
  