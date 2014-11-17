class AddImageidToProducts < ActiveRecord::Migration
  def change
    add_column :products, :image_id, :string
  end
end
