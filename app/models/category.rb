class Category < ActiveRecord::Base
  belongs_to :parent,
             :foreign_key => "parent_id",
             :class_name => "Category"

  has_many :children,
           :foreign_key => 'parent_id',
           :class_name => 'Category',
           :dependent => :delete_all
  has_and_belongs_to_many :products
end
