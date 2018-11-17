Rails.application.routes.draw do
  root :to => 'vendors_dashboard#index'
  mount ShopifyApp::Engine, at: '/'
  # mount using default path: /email_processor
  mount_griddler
  devise_for :vendors, controllers: {registrations: 'vendors/registrations'}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'welcome#home'
  get 'error-message' => 'welcome#error_message'
  resources :automated_responses do
    collection do
      post :turn_off
    end
  end
  resources :response_presets
  resources :vendors_dashboard, only: [:index, :show] do
    collection do
      post :customer_issues
      post :create_messages
      get :form_editor
      get :contact_us
    end
  end
  resources :disputes, only: [:index]

  # get 'welcome/home' => "welcome#home", as: :home
  get 'home/get_tracking_status' => "home#get_tracking_status", as: :get_tracking_status
  get 'home/add_to_store' => "home#add_to_store", as: :add_to_store
  get 'home/update_to_store' => "home#update_to_store", as: :update_to_store
  post 'home/app_uninstalled' => "home#app_uninstalled", as: :app_uninstalled

end
