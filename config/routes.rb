Rails.application.routes.draw do
  require "sidekiq/web"

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?

  mount Sidekiq::Web, at: "/sidekiq"
  mount Blazer::Engine, at: "blazer"

  resources :brainstorms, param: :token, only: [:create, :new, :edit, :update] do
    member do
      post :done_brainstorming, :start_brainstorm, :start_voting, :done_voting, :end_voting, :change_state
    end

    resource :timer, only: :update, module: "brainstorms" do
      resource :duration, only: :update, module: "timers"
    end

    resource :email, only: :create, module: "brainstorms"
  end

  resource :session, only: [] do
    resource :name, only: :update, module: "sessions"
  end

  get 'brainstorms/join-session', to: 'brainstorms#join_session'

  root 'brainstorms#new'

  resources :ideas, only: [:create] do
    post :show_idea_build_form, :vote
    resources :idea_builds, only: [:create] do
      post :vote
    end
  end

  resources :users, only: [:create]
  resources :sessions, only: [:create]

  get '/users/register', to: 'users#new'
  get '/users/sign_in', to: 'sessions#new'
  get '/users/sign_out', to: 'sessions#destroy'

  #google login
  get 'login', to: 'logins#new'
  get 'login/create', to: 'logins#create', as: :create_login

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/:token', to: 'brainstorms#show', as: 'brainstorm_show'

  post '/:token/downloads', to: 'brainstorms/downloads#download_pdf', as: 'download_brainstorm'

  post '/go_to_brainstorm', to: 'brainstorms#go_to_brainstorm'
  
  post '/:token/edit_problem', to: 'brainstorms#edit_problem', as: 'edit_problem'
end
