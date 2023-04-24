Rails.application.routes.draw do
  get 'pages/index'
  resources :organizations do
    match '/scrape', to: 'organizations#scrape', via: :post, on: :collection
    # match '/download', to: 'organizations#download', via: :post, on: :collection
    match '/delete', to: 'organizations#delete', via: :post, on: :collection
    match '/exclude', to: 'organizations#exclude', via: :post, on: :collection
    match 'exclude', to: 'organizations#exclude', via: :get, on: :collection
    collection do
      get :download
      get :delete_row
      get :edit_row
      post :add_table_entry
      post :display_columns
      get 'list'
    end
  end
  resources :contacts
  resources :contact_organizations
  resources :applications do
    collection do
      get :delete_row
      get :edit_row
      post :add_table_entry
      post :display_columns
      get 'list'
    end
  end
  resources :application_categories
  resources :categories
  resources :users

  match '/custom_view', to: 'organizations#custom_view', via: [:get, :post], as: :custom_view
  
  root to: 'organizations#index'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  # resources :pages
  match '/help', to: 'pages#index', via: :get
end