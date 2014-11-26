class AddShopToProducts < ActiveRecord::Migration
  def change
    add_column :products, :shop, :string
    add_column :products, :full_categories, :string
    add_column :products, :detail_compatibility, :string
  end
end
