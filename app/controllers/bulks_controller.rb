# TODO: program description
#
# Authors::    Justin Kim and Tyler Dary
# Copyright::
# License::

# Primary controller class for SEO Tool bulk form

class BulksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
  end

  def bulk
    @industries = Industry.all
    # @topics = Topic.all
    @customers = Customer.all
    @templates = Template.all
    @cities = City.all
    @states = State.all
  end

  def bulk_topics
    @topics = Industry.where(name: params[:industry]).first.topics
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  def bulk_template # this is for the bulk input form

    formattedVal = bulk_params[:customer].squish.titleize
    flash[:customer] = formattedVal
    customerCheck = Customer.find_or_create_by(name: formattedVal)
    if customerCheck.errors.present?
      puts "errors found in cust check"
      flash[:errors] = customerCheck.errors.full_messages
    else
      customer = customerCheck.id
    end

    formattedVal = bulk_params[:template].squish.titleize
    flash[:template] = formattedVal
    templateCheck = Customer.find(customer).templates.find_or_create_by(name: formattedVal)
    if templateCheck.errors.present?
      puts "errors found in temp check"
      flash[:errors] = templateCheck.errors.full_messages
    else
      template = templateCheck.id
    end

    formattedVal = bulk_params[:industry].squish.titleize
    flash[:industry] = formattedVal
    industryCheck = Industry.find_or_create_by(name: formattedVal)
    if industryCheck.errors.present?
      puts "errors found in industry check"
      flash[:errors] = industryCheck.errors.full_messages
    else
      industry = industryCheck.id
      @topics = industryCheck.topics
    end

    formattedVal = bulk_params[:topic].squish.titleize
    flash[:topic] = formattedVal
    topicCheck = Industry.find(industry).topics.find_or_create_by(name: formattedVal)
    if topicCheck.errors.present?
      puts "errors found in topic check"
      flash[:errors] = topicCheck.errors.full_messages
    else
      topic = topicCheck.id
    end

    #topic = Topic.create(name: bulk_params[:topic], industry_id: industry)

    formattedVal = bulk_params[:keyword1].squish.titleize
    flash[:keyword1] = formattedVal
    if formattedVal.present?
      keyword1Check = Topic.find(topic).keywords.find_or_create_by(keyword: formattedVal)
      if keyword1Check.errors.present?
        puts "errors found in key1 check"
        flash[:errors] = keyword1Check.errors.full_messages
      else
        keyword1 = keyword1Check.id
      end
    else
      keyword1 = ''
    end

    formattedVal = bulk_params[:keyword2].squish.titleize
    flash[:keyword2] = formattedVal
    if formattedVal.present?
      keyword2Check = Topic.find(topic).keywords.find_or_create_by(keyword: formattedVal)
      if keyword2Check.errors.present?
        puts "errors found in key2 check"
        flash[:errors] = keyword2Check.errors.full_messages
      else
        keyword2 = keyword2Check.id
      end
    else
      keyword2 = ''
    end

    formattedVal = bulk_params[:keyword3].squish.titleize
    flash[:keyword3] = formattedVal
    if formattedVal.present?
      keyword3Check = Topic.find(topic).keywords.find_or_create_by(keyword: formattedVal)
      if keyword3Check.errors.present?
        puts "errors found in key3 check"
        flash[:errors] = keyword3Check.errors.full_messages
      else
        keyword3 = keyword3Check.id
      end
    else
      keyword3 = ''
    end

    formattedVal = bulk_params[:heading1].squish.titleize
    flash[:heading1] = formattedVal
    if formattedVal.present? && keyword1.present?
      heading1Check = Keyword.find(keyword1).headings.find_or_create_by(heading: formattedVal)
      if heading1Check.errors.present?
        puts "errors found in h1 check"
        flash[:errors] = heading1Check.errors.full_messages
      else
        heading1 = heading1Check.id
      end
    else
      heading1 = ''
    end

    formattedVal = bulk_params[:heading2].squish.titleize
    flash[:heading2] = formattedVal
    if formattedVal.present? && keyword2.present?
      heading2Check = Keyword.find(keyword2).headings.find_or_create_by(heading: formattedVal)
      if heading2Check.errors.present?
        puts "errors found in h2 check"
        flash[:errors] = heading2Check.errors.full_messages
      else
        heading2 = heading2Check.id
      end
    else
      heading2 = ''
    end

    formattedVal = bulk_params[:heading3].squish.titleize
    flash[:heading3] = formattedVal
    if formattedVal.present? && keyword3.present?
      heading3Check = Keyword.find(keyword3).headings.find_or_create_by(heading: formattedVal)
      if heading3Check.errors.present?
        puts "errors found in h3 check"
        flash[:errors] = heading3Check.errors.full_messages
      else
        heading3 = heading3Check.id
      end
    else
      heading3 = ''
    end

    formattedVal = bulk_params[:meta].squish
    flash[:meta] = formattedVal
    if formattedVal.present?
      metaCheck = Topic.find(topic).metas.find_or_create_by(description: formattedVal)
      if metaCheck.errors.present?
        puts "errors found in meta check"
        flash[:errors] = metaCheck.errors.full_messages
      else
        meta = metaCheck.id
      end
    else
      meta = ''
    end


    formattedVal = bulk_params[:state].squish.titleize
    flash[:state] = formattedVal
    if formattedVal.present?
      stateCheck = State.find_or_create_by(name: formattedVal)
      if stateCheck.errors.present?
        puts "errors found in state check"
        flash[:errors] = stateCheck.errors.full_messages
      else
        state = stateCheck.id
      end
    else
      state = ''
    end

    formattedVal = bulk_params[:city].squish.titleize
    flash[:city] = formattedVal
    if formattedVal.present?
      cityCheck = State.find(state).cities.find_or_create_by(name: formattedVal)
      if cityCheck.errors.present?
        puts "errors found in city check"
        flash[:errors] = cityCheck.errors.full_messages
        redirect_to '/bulk_form'
        return
      else
        city = cityCheck.id
      end
    else
      city = ''
    end

    if flash[:errors].blank?
      # Might be a good idea to perform another round of validations here, especially for topic, industry, customer and template

      page = Template.find(template).pages.create(page_title: bulk_params[:title], topic_id: topic, k1_id: keyword1, k2_id: keyword2, k3_id: keyword3, h1_id: heading1, h2_id: heading2, h3_id: heading3, meta_id: meta, url: bulk_params[:url], city_id: city, state_id: state)

      Template.find(template).update(status: "published")

      flash[:success] = "Page added!"
    else
    end

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
      params.require(:bulk).permit(:title, :industry, :topic, :keyword1, :keyword2, :keyword3, :heading1, :heading2, :heading3, :meta, :customer, :template, :url, :city, :state)
    end

    def authenticate_user!
    if user_signed_in? # && current_user.id == params[:id].to_i
      # puts 'authenticated'
      return
    else
      puts 'unauthorized access'
      redirect_to new_user_session_path, :notice => "You must have permission to access this page."
    end
  end

end


# I also need to verify the associations...for example, if a keyword is entered once, can I use it for all things?
