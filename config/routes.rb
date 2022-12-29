Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/activate_account',
      to: 'registrations#activate_account',
      as: 'activate_account'
  # Defines the root path route ("/")
  # root "articles#index"
end
