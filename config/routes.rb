Rails.application.routes.draw do
  resources :brainstorms, param: :token, only: :create do
    member do
      post :set_user_name, :start_timer, :done_brainstorming, :send_ideas_email, :start_brainstorm, :start_voting, :done_voting, :end_voting, :change_state
    end
  end

  resources :ideas, only: [:create] do
      post :show_idea_build_form, :vote
    resources :idea_builds, only: [:create] do
      post :vote
    end
  end

  get '/about', to: 'pages#about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'brainstorms#index'

  get '/:token', to: 'brainstorms#show', as: 'brainstorm'
  
  get '/:token/download_pdf', to: 'brainstorms#download_pdf', as: 'download_pdf'

  post '/go_to_brainstorm', to: 'brainstorms#go_to_brainstorm'
end
