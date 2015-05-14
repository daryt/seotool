class MainsController < ApplicationController
  def index
  	@industry = Industry.new
  	@templates = Template.where(status: 'draft')
  	puts @templates
  end

  def sitemap
  	# create a check to see if we're starting a new template, or continuing an in-process one
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

  def new_topic
  	puts params
  	render :nothing => true
  end

end
