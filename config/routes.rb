# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :v1, module: "v1", defautls: { format: "json" } do
    post "/trainees/login", to: "trainees#login"

    resources :trainers, only: %i[index show]
  end
end
