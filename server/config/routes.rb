Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  scope :api do
    get 'book_slots/query'
    resources :book_slots, only: [:create]
  end
  # Ex:- scope :active, -> {where(:active => true)}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
