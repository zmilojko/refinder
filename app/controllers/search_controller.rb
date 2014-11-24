# -*- encoding : utf-8 -*-

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
      products: [],
      qid: params[:qid],
    }

    s_words.select{|word| word.length >= 2}.each do |word|
      # 1. Searching categories based on text input
      #    Use words of 2-3 letters for top level categories only,
      #    words of 4+ letters for any category.
      add_group_to_response name: 'Categories', 
        url: '/categories/', 
        replace: word,
        params: params,
        results: Category.where("#{"parent_id = 1 and " if word.length < 4}name like '%#{word.gsub(/[öäÖÄoaOA]/,'_')}%'").order(:name)
      
      # 2. Searching manufacturers based on text input
      add_group_to_response name: 'Car makers', 
        url: '/manufacturers/', 
        replace: word,
        params: params,
        results: Manufacturer.where("name like '%#{word.gsub(/[öäÖÄoaOA]/,'_')}%'").order(:name)
    end

    params[:selected_groups].each do |g|
      case g['type']
      when 'category'
        # 3. Subcategories of selected categories
        add_group_to_response name: "Narrow inside #{g['name']}", 
          url: '/categories/', 
          params: params,
          replace_box: { type: :category, id: g['id']},
          results: Category.find(g['id']).children

        # 4. Supercategories of selected categories
        parent_category = Category.find(g['id']).parent
        add_group_to_response name: "Widen from #{g['name']}", 
          url: '/categories/', 
          params: params,
          replace_box: { type: :category, id: g['id']},
          results: [parent_category] unless parent_category.nil?
      when 'manufacturer'
        # 5. Models of selected manufacturers
        add_group_to_response name: "Car models", 
          url: '/car_brands/', 
          params: params,
          replace_box: { type: :manufacturer, id: g['id']},
          results: CarBrand.where(manufacturer_id: g['id']).order(:name)
      end
    end
    # 6. Products based on text input
    puts "s_words is #{s_words}"
    criteria = s_words.select{|word| word.length >= 4}.map{|word| "name like '%#{word.gsub(/[öäÖÄoaOA]/,'_')}%'"}.join(" or ")
    puts "text_criteria is #{criteria}"
    models_to_search = []
    categories_to_search = []
    params[:selected_groups].each do |g|
      case g[:type]
      when "manufacturer"
        models_to_search.push(*(Manufacturer.find(g[:id]).car_brands))
      when "car_brand"
        models_to_search << CarBrand.find(g[:id])
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

  def add_group_to_response(response)
    # the following line cannot be map! results is activerecord::something, 
    # and this turns it into array, then we can use select!
    results = response[:results].map { |p| p.box_hash }
    response[:results] = nil
    params = response[:params]
    response[:params] = nil
    results.select! do |c| 
      c unless params[:selected_groups].any? do |g|
        g['type'] == c[:type].to_s and g['id'] == c[:id]
      end
    end
    results.each { |r|
      r[:replace] = response[:replace]
      r[:replace_box] = response[:replace_box]
    }
    response[:type] = :group_to_show
    response[:sub] = results
    @response[:groups] << response unless results.empty?
  end
  
  def include_this_and_children(categories_to_search, c)
    categories_to_search.push(*c)
    c.children.each { |child| include_this_and_children(categories_to_search, child) }
  end
end
