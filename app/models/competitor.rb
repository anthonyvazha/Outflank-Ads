class Competitor < ApplicationRecord
  include Companyable
  belongs_to :brand
  has_many :ads

  def user
    brand.user
  end
end
