# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :v1, module: "v1", defautls: { format: "json" } do
    post "/trainees/login", to: "trainees#login"

    resources :trainers, only: %i[index show] do
      resources :personal_classes, only: %i[create destroy]
    end
  end

  scope :internal, module: "internal", defaultls: { format: "json" } do
    post "/trainers/login", to: "trainers#login"

    resources :trainers, only: [] do
      resources :trainees, only: %i[index show]
    end
  end
end
