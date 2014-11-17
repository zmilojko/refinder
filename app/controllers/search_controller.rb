class SearchController < ApplicationController
  respond_to :html, :json
  def index
    render layout: false
  end

  def query
    puts params
    @response = { under_development: true }
    respond_to do |format|
      format.json { render json: @response }
    end
  end
end
