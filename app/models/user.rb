class User < ApplicationRecord
  include Signupable
  include Onboardable
  include Billable

  scope :subscribed, -> { where(paying_customer: true) }
  has_many :brands
  has_many :competitors, through: :brands
  has_many :newsletters, through: :brands
  has_many :ads, through: :brands
  has_many :ads, through: :competitors

  def ready_for_ai?
    # enriched_companies = brands.map(&:enriched?) + competitors.map(&:enriched?)
    # enriched_companies.uniq == [true] && ads.count.positive?
    competitors.all?(&:enriched?) && brands.all?(&:enriched?) && competitors.first.ads.count.positive?
 end
 
end
