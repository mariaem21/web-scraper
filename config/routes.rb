# frozen_string_literal: true

Rails.application.routes.draw do
  resources :organizations
  resources :contacts
  resources :applications
  resources :appcats
  resources :categories
  resources :users
  #   match '/scrape', to: 'student_orgs#scrape', via: :post, on: :collection
  # end

  # root to: 'student_orgs#index'
  root to: 'organizations#index'
end
