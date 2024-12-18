# frozen_string_literal: true

class Internal::ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :trainer

  rescue_from ActiveRecord::RecordNotFound do
    head(:not_found)
  end

  protected

  def encode(payload)
    JWT.encode(payload, nil, "none")
  end

  def auth_header
    @auth_header ||= request.headers["Authorization"]
  end

  def decoded_token
    @decoded_token ||=
      if auth_header
        token = auth_header.split[1]

        begin
          JWT.decode(token, nil, false)
        rescue JWT::DecodeError
          head(:unauthorized)
        end
      end
  end

  def trainer_id
    decoded_token[0]["trainer_id"]
  end

  def sign_in
    @trainer = Trainer.includes(:trainees, workouts: [:exercises]).find(trainer_id)
  end

  def authenticate_user!
    trainer_id && sign_in || head(:unauthorized)
  end
end
