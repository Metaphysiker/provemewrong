Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'
  get "angular_test", to: "angular_test#index"

  get '/test', to: "dashboard#test", as: 'test'
  post '/test', to: "dashboard#test"

  get '/argumentation', to: "dashboard#argumentation", as: 'argumentation'
  post '/argumentation', to: "dashboard#argumentation"

  get '/get_current_user', to: "dashboard#get_current_user"

  resources :argumentations, only: [ :index, :show, :create, :update]
  get '/getparentargumentation/:id', to: "argumentations#getparentargumentation"
  post '/addargumenttoargumentation/:id', to: "argumentations#addargumenttoargumentation"
  post'/deleteargumenttoargumentation/:id/', to: "argumentations#deleteargumenttoargumentation"
  get'/myargumentations', to: "argumentations#myargumentations"
  post'/deletefullargumentation/:id', to: "argumentations#deletefullargumentation"
end
