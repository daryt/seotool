class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_template

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || '/'
  end

  def current_template
  	if session[:current_template_id] != nil
  		if Template.exists?(id:session[:current_template_id])
  			return Template.find(session[:current_template_id])
  		end
  	end
  	return false
  end

  # def after_sign_in_path_for(resource)
  #   request.env['omniauth.origin'] || stored_location_for(resource) || '/modules/1'
  # end

end
