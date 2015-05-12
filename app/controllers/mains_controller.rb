class MainsController < ApplicationController
  def index
  	@industry = Industry.new
  	puts @industry
  end

  def select
  	puts params
  	render :nothing => true
  end

end
