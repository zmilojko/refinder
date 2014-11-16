puts "Loading products into the database. This will take a while..."

Category.delete_all
Product.delete_all
Manufacturer.delete_all
CarBrand.delete_all

$product_creation_counter = 0

def process_category(cat, cat_hash, top_level)
  cat_hash[:subcategories].each do |subcat_hash|
    subcat = cat.children.create!(name: subcat_hash[:name])
    process_category subcat, subcat_hash, false
    # break if top_level
  end if cat_hash[:subcategories]
  
  cat_hash[:products].each do |product_hash|
    $product_creation_counter = $product_creation_counter + 1
    puts "creating product #{product_hash[:name]} (#{$product_creation_counter})"
    prod = cat.products.create! pid: product_hash[:pid],
                                name: product_hash[:name],
                                price: product_hash[:price],
                                image_id: product_hash[:image_id]
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

@previously_accessed_models = []

def find_car_brand(manufacturer_name, car_brand_name)
  # First we check if we have already used this model. In
  # time, all the models will be in the list
  model_index = @previously_accessed_models.index { |cb| cb.name == car_brand_name and cb.manufacturer == manufacturer_name }
  if model_index.nil?
    #We need to create the car brand, and maybe also the manufacturer
    m = Manufacturer.find_by(name: manufacturer_name)
    if m.nil?
      m = Manufacturer.create! name: manufacturer_name
    end
    # Now we for sure have the manufacturer. Just get the car brand from it.
    cb = m.car_brands.where(name: car_brand_name)
    if cb.empty?
      cb = m.car_brands.create!(name: car_brand_name)
    end
    @previously_accessed_models << cb
    cb
  else
    cb = @previously_accessed_models[model_index]
  end
end

ActiveRecord::Base.transaction do
  main_category = Category.create! name: @biltema_products[:name]
  process_category main_category, @biltema_products, true
end
