Rails.application.routes.draw do
  resources :student_orgs do
    match '/scrape', to: 'student_orgs#scrape', via: :post, on: :collection
  end

  root to: 'student_orgs#index'
end
