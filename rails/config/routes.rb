Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  get '/api/features((/number/:number)(/page/:page)(/magtype/:magtype))', to: 'application#index'
  get '/api/features/:id', to: 'application#find'
  put '/api/features/:id', to: 'application#update'
  post '/api/features/:id/comment/new', to: 'application#add_comment'

end
