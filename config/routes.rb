# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  scope :v1, module: "v1", defautls: { format: "json" } do
    post "/trainees/login", to: "trainees#login"

    resources :trainers, only: %i[index show] do
      resources :personal_classes, only: %i[create destroy]
    end

    resources :trainees, only: [] do
      resources :assignments, only: %i[index show]
    end
  end

  scope :internal, module: "internal", defaultls: { format: "json" } do
    post "/trainers/login", to: "trainers#login"

    resources :trainers, only: [] do
      resources :trainees, only: %i[index show] do
        resources :assignments, only: %i[create]
      end
      resources :workouts, only: %i[index create show destroy update], param: :workout_id
    end
  end
end
