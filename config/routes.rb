Rails.application.routes.draw do
  resources :brainstorms
  resources :ideas
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'brainstorms#index'

  get '/set_user_name', to: 'brainstorms#set_user_name'
end
