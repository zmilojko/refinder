class Manufacturer < ActiveRecord::Base
  has_many :car_brands
  
  def box_hash
    { 
      name: name, 
      type: :manufacturer, 
      id: id 
    }
  end
end
