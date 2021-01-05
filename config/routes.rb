Rails.application.routes.draw do
  put '/document-check', to: 'unchecked_documents#check'
end
