class CarBrand < ActiveRecord::Base
  belongs_to :manufacturer
  has_and_belongs_to_many :products
  
  def box_hash
    {
      name: name, 
      name_selected: "#{manufacturer.name} #{name}", 
      type: :car_brand, 
      id: id 
    }
  end
end
