Rails.application.routes.draw do
  mount Manifester::Engine => "/manifester"
  root "home#index"
end
