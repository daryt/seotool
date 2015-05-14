class MainsController < ApplicationController
  def index
  	@industry = Industry.new
  	puts @industry
  end

  def sitemap
  	puts params[:industry][:id]
  	@topics = Industry.find(params[:industry][:id]).topics
  end

  def keywords
  	@topics = Hash.new;
  	puts params
  	params.each do |key,val|
  		puts val.to_i.to_s
  		if val.to_i > 0
  			@topics[key] = val.to_i
			puts "#{key} => #{val}"
		end
  	end
  	puts YAML::dump(@topics)

  end

end
