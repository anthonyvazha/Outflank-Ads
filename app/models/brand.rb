class Brand < ApplicationRecord
  include Companyable
  
  belongs_to :user
  has_many :competitors
  has_many :ads
  accepts_nested_attributes_for :competitors, 
  reject_if: proc { |attributes| attributes['ad_libary_url_facebook'].blank? }, 
  allow_destroy: true
  validates :ad_libary_url_facebook, format: { with: /\A#{URI::regexp(['http', 'https'])}\z/, message: "is not a valid URL" }



 

  
end
