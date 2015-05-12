class ModulesController < ApplicationController
	before_action :set_module, only: [:show]
	# before_action :set_cache_buster

  def index
  end

  def select
      if current_user
        render :select
      else
        redirect_to(new_user_registration_path);
      end
  end

  def show
      if current_user
    		puts params[:id]
    		@module_id = params[:id].to_i
    		# redirect_to :action => 'display', :id=>params[:id]
    		render params[:id]
      else
        redirect_to(new_user_registration_path);
      end
 	end

 	def partial
 		puts 'in partial'
    # puts params[:id]
    @module_id = params[:id].to_i
 		respond_to do |format|
	    	format.js
	  	end
 	end

  def complete
    # puts params[:id]
    @user = User.find(current_user.id)
    @user.increment!(:modules_completed, 1)
    puts params.inspect
    render :nothing => true
  end

 	# def display
 	# 	@module_id = params[:id].to_i
 	# 	render params[:id]
 	# end

 	def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  	private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_module
	      # @user = User.find(params[:id])
	    end
end
