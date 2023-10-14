class Ad < ApplicationRecord
    belongs_to :brand, optional: true
    belongs_to :competitor, optional: true
 
    has_rich_text :creatives

    def user
      brand&.user || competitor.user
    end
  end
  