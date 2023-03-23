Rails.application.routes.draw do
  resources :organizations do
    match '/scrape', to: 'organizations#scrape', via: :post, on: :collection
    match '/download', to: 'organizations#download', via: :post, on: :collection
    match '/delete', to: 'organizations#delete', via: :post, on: :collection
  end
  resources :contacts
  resources :contact_organizations
  resources :applications
  resources :application_categories
  resources :categories
  resources :users

  root to: 'organizations#index'
end
