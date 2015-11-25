DtuBlacklightCommon::Engine.routes.draw do
  resources :suggest, only: :index, defaults: { format: 'json' }
end
