class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :car_brands
  
  def target_url
    "#{categories[0].target_url}#{name.gsub " ", "-"}-#{pid}/"
  end
  
  def box_hash
    {
      name: name,
      id: id,
      pid: pid,
      price: price,
      image_id: image_id,
      url: target_url,
    }
  end
end
