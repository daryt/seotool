# TODO: program description
#
# Authors::    Justin Kim and Tyler Dary
# Copyright::
# License::

# Primary controller class for SEO Tool application

class MainsController < ApplicationController

  def index
  	# @template = Template.new
  	@templates = Template.where(status: 'draft')
  end

  # Create a new template and render the sitemap with default info
  def new_template

    customer_id = template_params[:customer_id]
    industry_id = template_params[:industry_id]

    if template_params[:customer_id] == 'New Customer'
      customer = Customer.create(name:params[:new_customer])
      customer_id = customer.id
    end
    if template_params[:industry_id] == 'New Industry'
      puts params
      industry = Industry.create(name:params[:new_industry])
      industry_id = industry.id
    end

    @template = Template.new(name:template_params[:name],industry_id:industry_id,customer_id:customer_id)

    if @template.save
        # puts template_params
        @industry = Industry.find(industry_id)
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

  # Render the sitemap page with existing pages checked
  def show_sitemap
    @template = Template.find(session[:current_template_id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    # puts YAML::dump(@pages)
    @topics = @industry.topics
    render :sitemap
  end

  # Update the template to reflect selected topics
  def update_topics
    pages_to_remove = []
    pages = Template.find(session[:current_template_id]).pages
    pages.each do |page|
      pages_to_remove.push(page.id)
    end

    # If the page doesn't exist, create it for this template
    params.each do |key,val|
      if key.include? '_topic'
        page = Template.find(session[:current_template_id]).pages.find_or_initialize_by(topic_id:val)
        pages_to_remove.reject! { |a| a == page.id }
        # puts page.topic_id
        page.save
      end
    end

    pages_to_remove.each { |a|
      Page.find(a).destroy
    }

    puts 'updating topics'

    redirect_to '/show_keywords'
  end

  # Get all the pages and render the keywords page
  def show_keywords
    @pages = Template.find(session[:current_template_id]).pages
    render :keywords
  end

  # Save the keyword ids into the pages for this template
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

  # Render the headings page
  def show_headings
    @pages = Template.find(session[:current_template_id]).pages
    render :headings
  end

  # Save the heading ids into the pages for this template
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

  # Render the metas page
  def show_metas
    @pages = Template.find(session[:current_template_id]).pages
    render :metas
  end

  # Save the meta ids into the pages for this template
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

  # Retrieve template info for an in-process template
  def retrieve_overview
    puts params[:id]
    @template = Template.find(params[:id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    session[:current_template_id] = params[:id]

    redirect_to '/sitemap/'
  end

  # Render the overview edit page
  def show_overview
    @template = Template.find(session[:current_template_id])
    @industry = Industry.find(@template.industry_id)
    @pages = @template.pages

    # For each page:
    # If there is no page title or URL, create a standard one
    # If there is no state_id, default to Washington (placeholder: this may be done in the model)
    @pages.each do |page|
      if !page['page_title'].present?
        if !page['k1_id'].present? && !page['k2_id'].present? && !page['k3_id'].present?
          puts 'not all keywords present'
        else
          page['page_title'] = Keyword.find(page['k1_id']).keyword + ' (*city*) (*state*) | ' + Keyword.find(page['k2_id']).keyword + ' (*city*) | ' + Keyword.find(page['k3_id']).keyword
          page.save
        end
      end
      if !page['url'].present?
        if !page['k1_id'].present?
          puts 'first keyword not present'
        else
          page['url'] = Keyword.find(page['k1_id']).keyword.downcase + '-(*city*)-(*state*)'
          page.save
        end
      end
      if !page['state_id'].present?
        puts 'creating state id'
        page['state_id'] = State.where(name: 'Washington').first.id
        page.save
      end
    end

    render :overview
  end

  # Process changes in the overview page
  def update_overview
    template = Template.find(session[:current_template_id])
    industry = Industry.find(template.industry_id)

    # Go through every input field and create/update as needed
    params.each do |key,val|
      # Skip any empty fields - the user can have blanks on the final edit page
      if !val.present?
        next
      end
      if key.include?'_topic'
        puts 'value: ' + val
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
      if key.include?'_keyword'
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
      if key.include?'_heading'
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
        val.strip!
        if val == ''
          page['h' + heading_id.to_s + '_id'] = ''
          page.save
          next
        end
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
      if key.include? '_pagetitle'
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
        puts page.page_title
        page.update(page_title: val)
        next
      end
      if key.include? '_url'
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
        puts page.page_title
        page.update(url: val)
        next
      end
      if key.include? '_state_id'
        puts key
        page_id = ''
        key.each_char { |c|
          if c != '_'
            page_id += c
          else
            break
          end
        }
        page = template.pages.find(page_id)
        if val == 'New State'
          new_state = params[page_id.to_s + '_new_state']
          new_state.strip!
          next if !new_state.present?
          state = State.find_or_create_by(name:new_state)
        end
        page.update(state_id: state.present? ? state.id : val)
        next
      end
      if key.include? '_city_id'
        puts key
        page_id = ''
        key.each_char { |c|
          if c != '_'
            page_id += c
          else
            break
          end
        }
        page = template.pages.find(page_id)
        if val == 'New City'

          new_city = params[page_id.to_s + '_new_city']
          new_city.strip!
          next if !new_city.present?
          puts "attempting to add new city"
          city = State.find(page.state_id).cities.find_or_create_by(name:new_city)
        end
        page.update(city_id: city.present? ? city.id : val)
        next
      end
    end

    redirect_to '/show_overview'
  end

  def export_template
    @template = Template.find(session[:current_template_id])
    # @industry = Industry.find(@template.industry_id)
    @pages = @template.pages
    puts 'attempting to send data'
    respond_to do |format|
      format.csv { send_data @pages.to_csv }
      format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  # Find or create a new topic from post data
  def new_topic
  	puts params
  	@topic = Industry.find(params[:industry_id]).topics.find_or_create_by(name:params[:name])
  	redirect_to '/partial/topics'
  end

  # Find or create a new keyword from post data
  def new_keyword
    puts params
    @keyword = Topic.find(params[:topic_id]).keywords.find_or_create_by(keyword:params[:keyword])
    redirect_to '/partial/keywords'
  end

  # Find or create a new heading from post data
  def new_heading
    puts params
    @heading = Keyword.find(params[:keyword_id]).headings.find_or_create_by(heading:params[:heading])
    redirect_to '/partial/headings'
  end

  # Find or create a new meta description from post data
  def new_meta
    puts params
    @meta = Topic.find(params[:topic_id]).metas.find_or_create_by(description:params[:description])
    redirect_to '/partial/metas'
  end

  # Generic handler for 'new' AJAX calls
  # Refreshes the content for the appropriate page to reflect newly added content
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
      params.require(:template).permit(:industry_id, :customer_id, :name)
    end

    def bulk_params
      params.require(:bulk).permit(:industry, :topic, :keyword1, :keyword2, :keyword3, :heading1, :heading2, :heading3, :meta, :customer, :template)
    end

end


# I also need to verify the associations...for example, if a keyword is entered once, can I use it for all things?
