class User < ApplicationRecord
  include Signupable
  include Onboardable
  include Billable

  scope :subscribed, -> { where(paying_customer: true) }
  has_many :brands
  has_many :newsletters, through: :brands
  has_many :ads, through: :brands
  has_many :ads, through: :competitors

end
