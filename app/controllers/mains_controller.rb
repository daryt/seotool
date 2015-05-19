class MainsController < ApplicationController

  def index
  	@template = Template.new
  	@templates = Template.where(status: 'draft')
  	puts @templates
  end

  def new_template
    @template = Template.new(template_params)
    if @template.save
        puts template_params
        @industry = Industry.find(template_params[:industry_id])
        @topics = @industry.topics
        session[:current_template_id] = @template[:id]
        render :sitemap
      else
        # format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
        flash[:errors] = @user.errors.full_messages
        redirect_to '/'
    end
  end

  def sitemap
  	# create a check to see if we're starting a new template, or continuing an in-process one
  	puts params[:industry][:id]

  	@topics = Industry.find(params[:industry][:id]).topics
  	@industry = params[:industry]
  end

  def keywords
  	@topics = Hash.new;
  	puts params
  	params.each do |key,val|
  		puts val.to_i.to_s
  		if key.include? '_topic'
  			@topics[key] = val.to_i
			puts "#{key} => #{val}"
		end
  	end
  	puts YAML::dump(@topics)
  end

  def headings
  	puts params
  	@view_data = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

  	# known issue: does not reset counter value after each new topic id
  	counter = 0;

  	params.each do |key,val|
  		if key.include? '_keyword'
  			counter += 1
  			# get topic id from post data
  			topic_id = ''
  			key.each_char { |c|
  				if c != '_'
					topic_id += c
				else
					break
				end
			}
			# puts topic_id
  			@view_data[topic_id]['keyword_' + counter.to_s] = val
  			# puts val
  		end
  	end
  	# puts @view_data
  	puts YAML::dump(@view_data)
  end

  def metas
  	@topics = Hash.new;
  	puts params
  	params.each do |key,val|
  		# puts val.to_i.to_s
  		if key.include? '_topic'
  			@topics[key] = val.to_i
			# puts "#{key} => #{val}"
		  end
  	end
  	puts YAML::dump(@topics)
  end

  def post_overview
    @topics = Hash.new;
    puts params
    params.each do |key,val|
      # puts val.to_i.to_s
      if key.include? '_topic'
        @topics[key] = val.to_i
      # puts "#{key} => #{val}"
      end
    end
    puts YAML::dump(@topics)
    render :overview
  end

  def show_overview
    # create a check to see if we're starting a new template, or continuing an in-process one
    puts params[:id]
    @template = Template.find(params[:id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    session[:current_template_id] = params[:id]

    # puts YAML::dump(@pages)



    # @topics = Industry.find(params[:id]).topics
    # @industry = params[:industry]


    # @topics = Hash.new;
    # puts params
    # params.each do |key,val|
    #   # puts val.to_i.to_s
    #   if key.include? '_topic'
    #     @topics[key] = val.to_i
    #   # puts "#{key} => #{val}"
    #   end
    # end
    # puts YAML::dump(@topics)
    render :overview
  end

  def new_topic
  	puts params
  	@topic = Industry.find(params[:industry_id]).topics.create(name:params[:name])
  	respond_to do |format|
	    msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
	    format.json  { render :json => msg } # don't do msg.to_json
	  end
  	# render :nothing => true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:industry_id, :name)
    end

end
