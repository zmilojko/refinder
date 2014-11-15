class CarBrand < ActiveRecord::Base
  belongs_to :manufacturer
  has_and_belongs_to_many :products
end
