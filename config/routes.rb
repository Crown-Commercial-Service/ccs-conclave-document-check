Rails.application.routes.draw do
  resources :documents, only: [:update]
  get '/health_check', to: 'health_check#index'
end
