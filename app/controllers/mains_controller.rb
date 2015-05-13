class MainsController < ApplicationController
  def index
  	@industry = Industry.new
  	puts @industry
  end

  def site_map
  	puts params[:industry][:id]
  	@topics = Industry.find(params[:industry][:id]).topics
  end

end
