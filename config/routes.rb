Rails.application.routes.draw do
  resources :organizations do
    match '/scrape', to: 'organizations#scrape', via: :post, on: :collection
    match '/download', to: 'organizations#download', via: :post, on: :collection
    match '/delete', to: 'organizations#delete', via: :post, on: :collection
    match '/exclude', to: 'organizations#exclude', via: :post, on: :collection
    match 'exclude', to: 'organizations#exclude', via: :get, on: :collection
    collection do
      get 'list'
    end
  end
  resources :contacts
    # collection do
    #   get 'list'
    # end
  #end
  resources :contact_organizations
  resources :applications
  resources :application_categories
  resources :categories
  resources :users

  match '/custom_view', to: 'organizations#custom_view', via: [:get, :post], as: :custom_view
  
  root to: 'organizations#index'
end
