Rails.application.routes.draw do
  mount Rack::HaproxyStatus::Endpoint.new(path: Rails.root.join('config/balancer_state')) => '/load_balancer_status'
  root to: 'app#index'

  resources :responses, defaults: { format: 'json' }, constraints: { format: 'json' }
end
