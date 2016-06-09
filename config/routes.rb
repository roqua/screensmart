Rails.application.routes.draw do
  mount Rack::HaproxyStatus::Endpoint.new(path: Rails.root.join('config/balancer_state')) => '/load_balancer_status'
  root to: 'app#index'

  resources :responses, only: [:create], defaults: { format: 'json' }, constraints: { format: 'json' }
  resources :domains, only: [:index], defaults: { format: 'json' }, constraints: { format: 'json' }

  get '*path' => 'app#index' # Handle routing using react-redux-router
end
