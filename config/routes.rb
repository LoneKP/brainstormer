Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: "users/registrations", 
    sessions: "users/sessions",
    confirmations: "users/confirmations" ,
    omniauth_callbacks: "users/omniauth_callbacks",
  }

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  require "sidekiq/web"
  require 'sidekiq-scheduler/web'

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end if Rails.env.production?

  mount Sidekiq::Web, at: "/sidekiq"

  authenticate :user, ->(user) { user.admin? } do
    mount Blazer::Engine, at: "analytics/blazer"
  end

  resources :brainstorms, param: :token, only: [:new, :edit, :update, :create] do
    member do
      post :done_brainstorming, :start_brainstorm, :start_voting, :done_voting, :end_voting, :change_state
    end

    resource :timer, only: :update, module: "brainstorms" do
      resource :duration, only: :update, module: "timers"
    end

    resource :settings, only: :update, module: "brainstorms"

    resource :email, only: :create, module: "brainstorms"
  end

  get 'brainstorms/join-session', to: 'brainstorms#join_session'

  resources :ideas, only: [:create, :destroy] do
    post :show_idea_build_form, :vote
    resource :idea_builds, only: [:create]
  end

  resources :mailer_unsubscribes, only: [:show] 

  get '/brainstorm-not-found', to: 'pages#pages_template'
  get '/about', to: 'pages#pages_template'
  get '/privacy-policy', to: 'pages#pages_template'
  get '/your-brainstorms', to: 'pages#your_brainstorms'
  get '/pricing', to: 'pages#pricing'
  
  get '/checkouts', to: 'subscriptions#checkout'
  get '/your-plan', to: 'subscriptions#your_plan'
  get '/free-trial', to: 'subscriptions#free_trial'

  devise_scope :user do
    get '/select-sign-up-method', to: 'users/registrations#select_sign_up_method'
    get '/sign-up-with-google', to: 'users/registrations#sign_up_with_google'
    get 'users/edit/notifications', to: 'users/registrations#edit_notifications'
    get 'users/edit/delete-account', to: 'users/registrations#delete_account'
  end

  root 'pages#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/blog', to: 'redirects#blog'

  get '/:token/room-full', to: 'brainstorms#room_full', as: 'brainstorm_room_full'
  
  get '/:token', to: 'brainstorms#show', as: 'brainstorm_show'

  post '/:token/downloads/pdf', to: 'brainstorms/downloads#download_pdf', as: 'download_brainstorm_pdf'
  post '/:token/downloads/csv', to: 'brainstorms/downloads#download_csv', as: 'download_brainstorm_csv'

  post '/go_to_brainstorm', to: 'brainstorms#go_to_brainstorm'
  
  post '/:token/edit_problem', to: 'brainstorms#edit_problem', as: 'edit_problem'
end
