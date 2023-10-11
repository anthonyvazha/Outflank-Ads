class Newsletter < ApplicationRecord
  belongs_to :brand
  has_rich_text :content
end
