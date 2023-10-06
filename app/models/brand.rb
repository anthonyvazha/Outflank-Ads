class Brand < ApplicationRecord
  belongs_to :user
  has_many :competitors
  has_many :ads
  accepts_nested_attributes_for :competitors, 
  reject_if: proc { |attributes| attributes['ad_libary_url_facebook'].blank? }, 
  allow_destroy: true


 

  
end
