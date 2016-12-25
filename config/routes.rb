Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'
  get "angular_test", to: "angular_test#index"
  get '/test', to: "dashboard#test", as: 'test'

  resources :argumentations, only: [ :index, :show]
  get '/getparentargumentation/:id', to: "argumentations#getparentargumentation"

end
