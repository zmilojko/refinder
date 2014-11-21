# -*- encoding : utf-8 -*-

class Product < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :car_brands
  
  def target_url
    (url || "#{categories[0].target_url}#{name.gsub " ", "-"}-#{pid}/").
      gsub("ä","a").gsub("Ä","A").gsub("ö","o").gsub("Ö","O")
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
  
  def self.create_urls
    ActiveRecord::Base.transaction do
      self.all.each do |p|
        p.url = p.target_url
        p.save
      end
    end
  end
end
