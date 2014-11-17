class SearchController < ApplicationController
  respond_to :html, :json
  def index
    render layout: false
  end

  def query
    s = params[:text]
    puts "Text criteria: #{s}"
    @response = { under_development: true }
    @response[:groups] = []
    @response[:groups] << {
      name: "Select car model",
      sub: Manufacturer.all.map { |m| { name: m.name, type: :manufacturer } }
    }
    @response[:groups] << {
      name: "Categories",
      sub: Category.where(parent_id: 1).map { |m| { name: m.name, type: :category } }
    }
    respond_to do |format|
      format.json { render json: @response }
    end
  end
end
