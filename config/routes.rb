Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  get "signup" => "users#new", :as => "signup"
  get "login" => "sessions#new", :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"
  get "episodeup" => "user_shows#last_episode_up", :as => "last_episode_up"
  get "episodedown" => "user_shows#last_episode_down", :as => "last_episode_down"
  get "seasonup" => "user_shows#last_season_up", :as => "last_season_up"
  get "seasondown" => "user_shows#last_season_down", :as => "last_season_down"
  get "episodes_available_down" => "user_shows#episodes_available_down", :as => "episodes_available_down"
  get "episodes_available_up" => "user_shows#episodes_available_up", :as => "episodes_available_up"
  get "add" => "user_shows#add_show_to_list", :as => "add"

  resources :users do
    resources :user_shows
  end
  resources :sessions
  resources :news
  resources :searches

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