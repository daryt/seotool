class MainsController < ApplicationController

  def index
  	@template = Template.new
  	@templates = Template.where(status: 'draft')
  	puts @templates
  end

  # create a new template and render the sitemap with default info
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

  # render the sitemap page with default info
  # def new_sitemap
  # 	puts params[:industry][:id]
  #   @template = Template.find(session[:current_template_id])
  #   @industry = params[:industry]
  #   @pages = @template.pages
  # 	@topics = Industry.find(params[:industry][:id]).topics
  #   render :sitemap
  # end

  # render the sitemap page with the already created pages marked
  def show_sitemap
    @template = Template.find(session[:current_template_id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    puts YAML::dump(@pages)
    @topics = @industry.topics
    render :sitemap
  end

  # update the template to reflect selected topics
  # create (and destroy?) topics as necessary
  # TODO: hook in destroy - unchecking doesn't do anything as of now
  def update_topics
    # if the page doesn't exist, create it for this template
    params.each do |key,val|
      if key.include? '_topic'
        page = Template.find(session[:current_template_id]).pages.find_or_initialize_by(topic_id:val)
        puts page.topic_id
        page.save
      end
    end

    redirect_to '/show_keywords'
  end

  # get all the pages and render the keywords page
  def show_keywords
    @pages = Template.find(session[:current_template_id]).pages
    render :keywords
  end

  # get all the pages and render the keywords page
  def update_keywords

    @pages = Template.find(session[:current_template_id]).pages



    @view_data = Hash.new{ |h,k| h[k] = Hash.new(&h.default_proc) }

    counter = 1

    params.each do |key,val|
      if key.include? '_keyword'
        topic_id = ''
        key.each_char { |c|
          if c != '_'
            topic_id += c
          else
            break
          end
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        case counter
        when 1
          page.k1_id = val
        when 2
          page.k2_id = val
        when 3
          page.k3_id = val
        end
        page.save
        counter += 1
        }
        # top = topic_id.to_i
        # puts top

        # page = Template.find(session[:current_template_id]).pages.find_or_initialize_by(topic_id:val)
        # puts page.topic_id
        # page.save
      end

      counter = 1 if counter > 3

    end
    render :headings
    # redirect_to '/show_keywords'
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

    redirect_to '/sitemap/'
    # render :overview
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
