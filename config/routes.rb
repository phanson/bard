Rails.application.routes.draw do
  resources :people
  resources :tags
  resources :resource_types
  resources :resources
  resources :passages
end
