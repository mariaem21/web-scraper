Rails.application.routes.draw do
  resources :organizations do
    match '/scrape', to: 'organizations#scrape', via: :post, on: :collection
    match '/download', to: 'organizations#download', via: :post, on: :collection
    match '/delete', to: 'organizations#delete', via: :post, on: :collection
    match '/exclude', to: 'organizations#exclude', via: :post, on: :collection
    match 'exclude', to: 'organizations#exclude', via: :get, on: :collection
    collection do
      get :delete_row
      post :add_table_entry
      post :delete_table_entry
      post :display_columns
      # post :delete_row
      get 'list'
    end
  end
  resources :contacts
  resources :contact_organizations
  resources :applications do
    collection do
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
end
