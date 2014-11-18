class SearchController < ApplicationController
  respond_to :html, :json
  def index
    render layout: false
  end

  def query
    s_words = params[:text].split
    puts "Text criteria: #{s_words}"
    @response = {}
    @response = { 
      groups: [], 
      products_url: "/products/", 
      products: []
    }

    s_words.select{|word| word.length >= 2}.each do |word|
      # 1. Searching categories based on text input
      #    Use words of 2-3 letters for top level categories only,
      #    words of 4+ letters for any category.
      results = Category.where("#{"parent_id = 1 and " if word.length < 4}name like '%#{word}%'").map { |c| { name: c.name, type: :category, id: c.id } }
      @response[:groups] << {
        name: "Categories",
        type: :group_to_show,
        base_url: "/categories/",
        sub: results,
        replace: word,
      } unless results.empty?
      # 2. Searching manufacturers based on text input
      results = Manufacturer.where("name like '%#{word}%'").map { |m| { name: m.name, type: :manufacturer, id: m.id } }
      @response[:groups] << {
        name: "Select car model",
        type: :group_to_show,
        base_url: "/categories/",
        sub: results,
        replace: word,
      } unless results.empty?
    end

    # 3. Subcategories of selected categories
    # 4. Supercategories of selected categories
    # 5. Models of selected manufacturers
    
    # 6. Products based on text input
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
