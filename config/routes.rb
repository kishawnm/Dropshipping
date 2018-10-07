Rails.application.routes.draw do
  # root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # mount using default path: /email_processor
  mount_griddler
  devise_for :vendors
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'welcome#home'
  get 'error-message' => 'welcome#error_message'
  resources :automated_responses
  resources :response_presets
  resources :vendors_dashboard, only: [:index, :show] do
    collection do
      post :customer_issues
      post :create_messages
    end
  end

  get 'welcome/home' => "welcome#home", as: :home
  get 'home/get_tracking_status' => "home#get_tracking_status", as: :get_tracking_status

end
