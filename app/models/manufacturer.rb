class Manufacturer < ActiveRecord::Base
  has_many :car_brands, -> { order(name: :asc) }
  
  def box_hash
    { 
      name: name, 
      type: :manufacturer, 
      id: id 
    }
  end
end
