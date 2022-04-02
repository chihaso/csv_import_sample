Rails.application.routes.draw do
  root "regions#index"
  resources :regions
  post 'populations', to: 'populations#upload'
end
