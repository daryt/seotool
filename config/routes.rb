Rails.application.routes.draw do

  # resources :industries

  # post '/overview/' => 'mains#post_overview'
  get '/export_template' => 'mains#export_template', as: 'export'

  post '/retrieve_overview/' => 'mains#retrieve_overview'
  get '/show_overview' => 'mains#show_overview'
  post '/update_overview' => 'mains#update_overview'
  post '/refresh_url' => 'mains#refresh_url'
  post '/refresh_page_title' => 'mains#refresh_page_title'

  get '/show_templates' => 'mains#show_template'
  post '/templates/' => 'mains#new_template'

  get '/sitemap' => 'mains#show_sitemap'
  post '/update_topics/' => 'mains#update_topics'
  post '/topics/new' => 'mains#new_topic'

  get '/show_keywords' => 'mains#show_keywords'
  post '/update_keywords/' => 'mains#update_keywords'
  post '/keywords/new' => 'mains#new_keyword'

  get '/show_headings' => 'mains#show_headings'
  post '/headings/new' => 'mains#new_heading'
  post '/update_headings/' => 'mains#update_headings'

  get '/show_metas' => 'mains#show_metas'
  post '/metas/new' => 'mains#new_meta'
  post '/update_metas/' => 'mains#update_metas'

  get '/partial/:section' => 'mains#partial'

  get '/' => 'mains#index'

  get '/bulk_form' => 'bulks#bulk' # for entering bulk templates
  post '/bulk' => 'bulks#bulk_template' #creating bulk templates

  get '/bulk_topics/:industry' => 'bulks#bulk_topics'

  devise_for :users, :controllers => { registrations: 'users/registrations', sessions: 'users/sessions' }

  # resources :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'mains#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
