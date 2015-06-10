# TODO: program description
#
# Authors::    Justin Kim and Tyler Dary
# Copyright::
# License::

# Primary controller class for SEO Tool application

class MainsController < ApplicationController

  def index
  	@template = Template.new
  	@templates = Template.where(status: 'draft')
  end

  # Create a new template and render the sitemap with default info
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

    render :overview
  end

  # Process changes in the overview page
  def update_overview
    template = Template.find(session[:current_template_id])
    industry = Industry.find(template.industry_id)

    # Go through every input field and create/update as needed
    params.each do |key,val|
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
    end

    redirect_to '/show_overview'
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
