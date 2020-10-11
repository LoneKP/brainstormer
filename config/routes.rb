Rails.application.routes.draw do
  resources :brainstorms, param: :token, only: :create do
    member do
      post :set_user_name, :start_timer, :send_ideas_email, :start_workshop
    end
  end

  resources :ideas, only: [:create, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'brainstorms#index'

  get '/:token', to: 'brainstorms#show', as: 'brainstorm'

  post '/go_to_brainstorm', to: 'brainstorms#go_to_brainstorm'
end
