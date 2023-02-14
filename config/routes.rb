Rails.application.routes.draw do

  root 'student_orgs#index'
  resources :student_orgs do
    match '/scrape', to: 'student_orgs#scrape', via: :post, on: :collection
  end

  root to: 'student_orgs#index'
end
