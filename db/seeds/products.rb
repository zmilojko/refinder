puts "Loading products into the database. This will take a while..."

Category.delete_all
Product.delete_all
Manufacturer.delete_all
CarBrand.delete_all

def process_category(cat, cat_hash, top_level)
  cat_hash[:subcategories].each do |subcat_hash|
    subcat = cat.children.create!(name: subcat_hash[:name])
    process_category subcat, subcat_hash, false
    # break if top_level
  end if cat_hash[:subcategories]
  
  cat_hash[:products].each do |product_hash|
    puts "creating product #{product_hash[:name]}"
    prod = cat.products.create! pid: product_hash[:pid],
                                name: product_hash[:name],
                                price: product_hash[:price]
    process_product prod, product_hash
  end if cat_hash[:products]
end

def process_product(prod, prod_hash)
  if prod_hash[:sopii]
    prod_hash[:sopii].each do |sopii_hash|
      manufacturer_name = sopii_hash[:brand]
      sopii_hash[:models].each do |car_brand_name|
        prod.car_brands.<< find_car_brand(manufacturer_name, car_brand_name)
      end
    end
    prod.save
  end
end

@models = Hash.new { |h, (manufacturer, brand)|
  m = Manufacturer.find_or_create_by!(name: manufacturer)
  cb = m.car_brands.find_or_create_by!(name: brand)
  h[[manufacturer, brand]] = cb
}

def find_car_brand(manufacturer_name, car_brand_name)
  @models[[manufacturer_name, car_brand_name]]
end

ActiveRecord::Base.transaction do
  main_category = Category.create! name: @biltema_products[:name]
  process_category main_category, @biltema_products, true
end
