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

  # save the keyword ids into the pages for this template
  def update_keywords

    @pages = Template.find(session[:current_template_id]).pages

    counter = 1

    params.each do |key,val|

      if key.include? '_keyword'
        topic_id = ''
        # puts key
        key.each_char { |c|
          if c != '_'
            topic_id += c
          else
            break
          end
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        # puts counter
        page['k' + counter.to_s + '_id'] = val
        page.save
        counter += 1
        }
      end

      counter = 1 if counter > 3

    end
    redirect_to '/show_headings'
  end

  def show_headings
    @pages = Template.find(session[:current_template_id]).pages
    render :headings
  end

  # save the heading ids into the pages for this template
  def update_headings

    @pages = Template.find(session[:current_template_id]).pages

    counter = 1

    params.each do |key,val|
      if key.include? '_heading'
        topic_id = ''
        key.each_char { |c|
          if c != '_'
            topic_id += c
          else
            break
          end
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        page['h' + counter.to_s + '_id'] = val
        page.save
        counter += 1
        }
      end

      counter = 1 if counter > 3

    end
    redirect_to '/show_metas'
  end

  def show_metas
    @pages = Template.find(session[:current_template_id]).pages
    render :metas
  end

  def update_metas

    @pages = Template.find(session[:current_template_id]).pages

    params.each do |key,val|
      if key.include? '_meta'
        topic_id = ''
        key.each_char { |c|
          if c != '_'
            topic_id += c
          else
            break
          end
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        page['meta_id'] = val
        page.save
        }
      end

    end
    redirect_to '/show_overview'
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

  def retrieve_overview
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

  def show_overview
    # create a check to see if we're starting a new template, or continuing an in-process one
    # puts params[:id]
    @template = Template.find(session[:current_template_id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    # session[:current_template_id] = params[:id]

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

    # redirect_to '/sitemap/'
    render :overview
  end

  def new_topic
  	puts params
  	@topic = Industry.find(params[:industry_id]).topics.create(name:params[:name])
  	redirect_to '/partial/topics'
  	# render :nothing => true
  end

  def new_keyword
    puts params
    @keyword = Topic.find(params[:topic_id]).keywords.create(keyword:params[:keyword])
    # respond_to do |format|
    #   msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
    #   format.json  { render :json => msg } # don't do msg.to_json
    # end
    redirect_to '/partial/keywords'
  end

  def new_heading
    puts params
    @heading = Keyword.find(params[:keyword_id]).headings.create(heading:params[:heading])
    redirect_to '/partial/headings'
  end

  def new_meta
    puts params
    @meta = Topic.find(params[:topic_id]).metas.create(description:params[:description])
    redirect_to '/partial/metas'
  end

  def partial
    puts 'in partial'
    @pages = Template.find(session[:current_template_id]).pages
    if params[:section] == 'topics'
      @template = Template.find(session[:current_template_id])
      @industry = Industry.find(@template.industry_id)
      @topics = @industry.topics
    end
    @section_id = params[:section]
    respond_to do |format|
      format.js
    end
  end

  def bulk
    @industries = Industry.all
    @topics = Topic.all
    @customers = Customer.all
    @templates = Template.all
  end
  def bulk_template # this is for the bulk input form
    
    industryCheck = Industry.where(name: bulk_params[:industry]).pluck(:id).first
    if industryCheck.nil?
      newIndustry = Industry.create(name: bulk_params[:industry])
      industry = newIndustry.id
    else
      industry = industryCheck
    end

    topicCheck = Industry.find(industry).topics.where(name: bulk_params[:topic]).pluck(:id).first
    if topicCheck.nil?
      newTopic = Industry.find(industry).topics.create(name: bulk_params[:topic])
      topic = newTopic.id
    else
      topic = topicCheck
    end

    #topic = Topic.create(name: bulk_params[:topic], industry_id: industry)

     
    keyword1Check = Topic.find(topic).keywords.where(keyword: bulk_params[:keyword1]).pluck(:id).first
      if keyword1Check.nil?
        newKeyword = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword1])
        keyword1= newKeyword.id
      else
        keyword1 = keyword1Check
    end

     keyword2Check = Topic.find(topic).keywords.where(keyword: bulk_params[:keyword2]).pluck(:id).first
      if keyword2Check.nil?
        newKeyword = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword2])
        keyword2= newKeyword.id
      else
        keyword2 = keyword2Check
    end

     keyword3Check = Topic.find(topic).keywords.where(keyword: bulk_params[:keyword3]).pluck(:id).first
      if keyword3Check.nil?
        newKeyword = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword3])
        keyword3= newKeyword.id
      else
        keyword3 = keyword3Check
    end


    # keyword1 = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword1])
    # keyword2 = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword2])
    # keyword3 = Topic.find(topic).keywords.create(keyword: bulk_params[:keyword3])

      heading1Check = Keyword.find(keyword1).headings.where(heading: bulk_params[:heading1]).pluck(:id).first
      if heading1Check.nil?
        newHeading = Keyword.find(keyword1).headings.create(heading: bulk_params[:heading1])
        heading1= newHeading.id
      else
        heading1 = heading1Check
    end

      heading2Check = Keyword.find(keyword2).headings.where(heading: bulk_params[:heading2]).pluck(:id).first
      if heading2Check.nil?
        newHeading = Keyword.find(keyword2).headings.create(heading: bulk_params[:heading2])
        heading2= newHeading.id
      else
        heading2 = heading2Check
    end

      heading3Check = Keyword.find(keyword3).headings.where(heading: bulk_params[:heading3]).pluck(:id).first
      if heading3Check.nil?
        newHeading = Keyword.find(keyword3).headings.create(heading: bulk_params[:heading3])
        heading3= newHeading.id
      else
        heading3 = heading3Check
    end

    # heading1 = Keyword.find(keyword1).headings.create(heading: bulk_params[:heading1])
    # heading2 = Keyword.find(keyword2).headings.create(heading: bulk_params[:heading2])
    # heading3 = Keyword.find(keyword3).headings.create(heading: bulk_params[:heading3])
    

    metaCheck = Topic.find(topic).metas.where(description: bulk_params[:meta]).pluck(:id).first
      if metaCheck.nil?
        newMeta = Topic.find(topic).metas.create(description: bulk_params[:meta])
        meta = newMeta.id
      else
        meta = metaCheck
    end

    # meta = Topic.find(topic).metas.create(description: bulk_params[:meta])
  
    
    customerCheck = Customer.where(name: bulk_params[:customer]).pluck(:id).first
    if customerCheck.nil?
      newCustomer = Customer.create(name: bulk_params[:customer])
      customer = newCustomer.id
    else
      customer = customerCheck
    end

    templateCheck = Customer.find(customer).templates.where(name: bulk_params[:template]).pluck(:id).first
    if templateCheck.nil?
      newTemplate = Customer.find(customer).templates.create(name: bulk_params[:template], industry_id: industry)
      template = newTemplate.id
    else
      template = templateCheck
    end

    page = Template.find(template).pages.create(topic_id: topic, k1_id: keyword1, k2_id: keyword2, k3_id: keyword3, h1_id: heading1, h2_id: heading2, h3_id: heading3, meta_id: meta)




    redirect_to '/bulk_form'
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

    def bulk_params
      params.require(:bulk).permit(:industry, :topic, :keyword1, :keyword2, :keyword3, :heading1, :heading2, :heading3, :meta, :customer, :template)
    end

end


# I also need to verify the associations...for example, if a keyword is entered once, can I use it for all things?
