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
      name: "Select car model",
      base_url: "/categories/",
      sub: Manufacturer.all.map { |m| { name: m.name, type: :manufacturer, id: m.id } }
    }
    @response[:groups] << {
      name: "Categories",
      base_url: "/categories/",
      sub: Category.where(parent_id: 1).map { |c| { name: c.name, type: :category, id: c.id } }
    }
    @response[:products_url] = "/products/"
    
    criteria = s.split.select{|word| word.length >= 4}.map{|word| "name like '%#{word}%'"}.join(" or")
    puts "Product search: #{criteria}"
    @response[:products] = Product.where(criteria).map { |p| 
      {
        name: p.name,
        id: p.id,
        pid: p.pid,
        price: p.price,
      } }
      
    
    respond_to do |format|
      format.json { render json: @response }
    end
  end
end
