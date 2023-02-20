Rails.application.routes.draw do
  resources :organizations
  #   match '/scrape', to: 'student_orgs#scrape', via: :post, on: :collection
  # end

  # root to: 'student_orgs#index'
  root to: 'organizations#index'
end
