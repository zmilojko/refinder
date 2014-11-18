class Category < ActiveRecord::Base
  belongs_to :parent,
             :foreign_key => "parent_id",
             :class_name => "Category"

  has_many :children,
           :foreign_key => 'parent_id',
           :class_name => 'Category',
           :dependent => :delete_all
  has_and_belongs_to_many :products

  def target_url
    url || if parent.nil?
      "http://www.biltema.fi/fi/Autoilu---MP/Autonvaraosat/"
    else
      "#{parent.target_url}#{name.gsub " ", "-"}/"
    end
  end
  
  def box_hash
    {
      name: name, 
      type: :category, 
      id: id,
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
