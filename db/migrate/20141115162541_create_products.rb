class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :pid
      t.string :name
      t.decimal :price
      t.string :url

      t.timestamps
    end
    create_table :categories_products do |t|
      t.integer :product_id
      t.integer :category_id
      t.timestamps
    end
    create_table :car_brands_products do |t|
      t.integer :product_id
      t.integer :car_brand_id
      t.timestamps
    end
  end
end
