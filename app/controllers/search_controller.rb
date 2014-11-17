class SearchController < ApplicationController
  respond_to :html, :json
  def index
    render layout: false
  end

  def query
    s = params[:text]
    puts "Text criteria: #{s}"
    @response = {}
    @response[:groups] = []
    @response[:groups] << {
      name: "Categories",
      type: :group_to_show,
      base_url: "/categories/",
      sub: Category.where(parent_id: 1).map { |c| { name: c.name, type: :category, id: c.id } }
    }
    @response[:groups] << {
      name: "Select car model",
      type: :group_to_show,
      base_url: "/categories/",
      sub: Manufacturer.all.map { |m| { name: m.name, type: :manufacturer, id: m.id } }
    }
    @response[:products_url] = "/products/"
    
    criteria = s.split.select{|word| word.length >= 4}.map{|word| "name like '%#{word}%'"}.join(" or")
    models_to_search = []
    categories_to_search = []
    params[:selected_groups].each do |g|
      case g[:type]
      when "manufacturer"
        models_to_search.push(*(Manufacturer.find(g[:id]).car_brands))
      when "category"
        c = Category.find(g[:id])
        include_this_and_children categories_to_search, c
      end
    end unless params[:selected_groups].nil?
    
    unless criteria.empty? and models_to_search.empty? and categories_to_search.empty?
      criteria = "2>1" if criteria.empty?
      criteria = "#{criteria} and id in (select product_id from car_brands_products where car_brand_id in (#{models_to_search.empty? ? 0 : models_to_search.map{|m|m.id}.join(",")}))" unless models_to_search.empty?
      criteria = "#{criteria} and id in (select product_id from categories_products where category_id in (#{categories_to_search.empty? ? 0 : categories_to_search.map{|m|m.id}.join(",")}))" unless categories_to_search.empty?
      puts "Product search: #{criteria}"

      selected_products = Product.where(criteria)

      @response[:products] = selected_products.map { |p| {
                                                           name: p.name,
                                                           id: p.id,
                                                           pid: p.pid,
                                                           price: p.price,
                                                           image_id: p.image_id
                                                         } 
                                                   }
    end
    
    respond_to do |format|
      format.json { render json: @response }
    end
  end
  
  def include_this_and_children(categories_to_search, c)
    categories_to_search.push(*c)
    c.children.each { |child| include_this_and_children(categories_to_search, child) }
  end
end
