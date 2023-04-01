Rails.application.routes.draw do
  resources :organizations do
    match '/scrape', to: 'organizations#scrape', via: :post, on: :collection
    match '/download', to: 'organizations#download', via: :post, on: :collection
    match '/delete', to: 'organizations#delete', via: :post, on: :collection
    match '/exclude', to: 'organizations#exclude', via: :post, on: :collection
    match 'exclude', to: 'organizations#exclude', via: :get, on: :collection
  end
  resources :contacts
  resources :applications
  resources :appcats
  resources :categories
  resources :users

  root to: 'organizations#index'
end
