class Ad < ApplicationRecord
    belongs_to :brand
    belongs_to :competitor, optional: true
    has_many :competitors
 
    has_rich_text :creatives

    def user
      brand&.user || competitor.user
    end
  end
  