Rails.application.routes.draw do
  resources :documents, only: [:update]
end
