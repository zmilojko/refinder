class SearchController < ApplicationController
  def index
    render layout: false
  end

  def query
    response = { under_development: true }
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render response }
    end
  end
end
