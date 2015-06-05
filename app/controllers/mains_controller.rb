class MainsController < ApplicationController

  def index
  	@template = Template.new
  	@templates = Template.where(status: 'draft')
  	# puts @templates
  end

  # create a new template and render the sitemap with default info
  def new_template
    @template = Template.new(template_params)
    if @template.save
        puts template_params
        @industry = Industry.find(template_params[:industry_id])
        @topics = @industry.topics
        @pages = @template.pages
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
    # puts YAML::dump(@pages)
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
        }
        puts topic_id + ' topic id'
        page = @pages.find_by_topic_id(topic_id)
        # puts page.id
        # puts counter
        page['k' + counter.to_s + '_id'] = val
        page.save
        counter += 1
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
        }
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        page['h' + counter.to_s + '_id'] = val
        page.save
        counter += 1
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
        }
        page = @pages.find_by_topic_id(topic_id)
        puts page.id
        page['meta_id'] = val
        page.save
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

  def update_overview

    template = Template.find(session[:current_template_id])
    industry = Industry.find(template.industry_id)

    # go through every input field and save the information
    params.each do |key,val|
      if key.include? '_topic'
        page_id = ''
        key.each_char { |c|
          if c != '_'
            page_id += c
          else
            break
          end
        }
        page = template.pages.find(page_id)
        puts page_id + ' page_id'
        val.strip!
        topic = industry.topics.find_or_initialize_by(name:val)
        topic.save
        page.topic_id = topic.id
        page.save
        next
      end
      if key.include? '_keyword'
        page_id = ''
        keyword_id = ''
        underscore_count = 0;
        key.each_char { |c|
          if c != '_'
            if underscore_count >= 1
              keyword_id += c
            else
              page_id += c
            end
          else
            underscore_count += 1 if c == '_'
            if (underscore_count >= 2)
              break
            end
          end
        }
        page = template.pages.find(page_id)
        puts page_id + ' page_id'
        puts page.topic_id.to_s + ' topic_id'
        val.strip!
        puts 'keyword: ' + val
        keyword = Topic.find(page.topic_id).keywords.where(keyword:val).first
        if !keyword
          keyword = Topic.find(page.topic_id).keywords.create(keyword:val)
        end
        page['k' + keyword_id.to_s + '_id'] = keyword.id
        page.save
        next
      end
      if key.include? '_heading'
        page_id = ''
        heading_id = ''
        underscore_count = 0;
        key.each_char { |c|
          if c != '_'
            if underscore_count >= 1
              heading_id += c
            else
              page_id += c
            end
          else
            underscore_count += 1 if c == '_'
            if (underscore_count >= 2)
              break
            end
          end
        }
        page = template.pages.find(page_id)
        # puts page_id + ' page_id'
        # puts page.topic_id.to_s + ' topic_id'
        val.strip!
        puts 'heading: ' + val
        heading = Keyword.find(page['k' + heading_id.to_s + '_id']).headings.where(heading:val).first
        if !heading
          heading = Keyword.find(page['k' + heading_id.to_s + '_id']).headings.create(heading:val)
        end
        page['h' + heading_id.to_s + '_id'] = heading.id
        page.save
        next
        end
      if key.include? '_meta'
        page_id = ''
        key.each_char { |c|
          if c != '_'
            page_id += c
          else
            break
          end
        }
        page = template.pages.find(page_id)
        puts page_id + ' page_id'
        val.strip!
        meta = Topic.find(page.topic_id).metas.find_or_initialize_by(description:val)
        meta.save
        page.meta_id = meta.id
        page.save
        next
      end
    end

    redirect_to '/show_overview'
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
