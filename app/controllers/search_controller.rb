class SearchController < ApplicationController
  respond_to :html, :json
  def index
    render layout: false
  end

  def query
    Category.all
    
    # A little bit of sanitation - we prefer empty than nil
    params[:text] ||= ""
    params[:selected_groups] ||= []
    
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
      add_group_to_response name: 'Click to select one or more categories', 
        url: '/categories/', 
        replace: word,
        params: params,
        results: Category.where("#{"parent_id = 1 and " if word.length < 4}name like '%#{word}%'")
      
      # 2. Searching manufacturers based on text input
      add_group_to_response name: 'Click to select your car', 
        url: '/manufacturers/', 
        replace: word,
        params: params,
        results: Manufacturer.where("name like '%#{word}%'")
    end

    params[:selected_groups].each do |g|
      case g['type']
      when 'category'
        # 3. Subcategories of selected categories
        add_group_to_response name: "Narrow your search in category #{g['name']}", 
        url: '/categories/', 
        params: params,
        replace_box: { type: :category, id: g['id']},
        results: Category.find(g['id']).children

        # 4. Supercategories of selected categories
        parent_category = Category.find(g['id']).parent
        add_group_to_response name: "Widen your search in category #{g['name']}", 
        url: '/categories/', 
        params: params,
        replace_box: { type: :category, id: g['id']},
        results: [parent_category] unless parent_category.nil?
      when 'manufacturer'
        # 5. Models of selected manufacturers
        add_group_to_response name: "Select model for #{g['name']}", 
        url: '/car_brands/', 
        params: params,
        replace_box: { type: :manufacturer, id: g['id']},
        results: CarBrand.where(manufacturer_id: g['id'])
      end
    end
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
    
    unless models_to_search.empty? and categories_to_search.empty?
      criteria = "2>1" if criteria.empty?
      criteria = "#{criteria} and id in (select product_id from car_brands_products where car_brand_id in (#{models_to_search.empty? ? 0 : models_to_search.map{|m|m.id}.join(",")}))" unless models_to_search.empty?
      criteria = "#{criteria} and id in (select product_id from categories_products where category_id in (#{categories_to_search.empty? ? 0 : categories_to_search.map{|m|m.id}.join(",")}))" unless categories_to_search.empty?
    end
    
    unless criteria.empty?
      puts "Product search: #{criteria}"
      selected_products = Product.where(criteria)
      @response[:products] = selected_products.map { |p| p.box_hash }
    end
    respond_to do |format|
      format.json { render json: @response }
    end
  end
  
  private

  def add_group_to_response(results: [], params: nil, **response)
    # the following line cannot be map! results is activerecord::something, 
    # and this turns it into array, then we can use select!
    results = results.map { |p| p.box_hash }
    results.select! do |c| 
      c unless params[:selected_groups].any? do |g|
        g['type'] == c[:type].to_s and g['id'] == c[:id]
      end
    end
    response[:type] = :group_to_show
    response[:sub] = results
    @response[:groups] << response unless results.empty?
  end
  
  def include_this_and_children(categories_to_search, c)
    categories_to_search.push(*c)
    c.children.each { |child| include_this_and_children(categories_to_search, child) }
  end
end
