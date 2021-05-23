# frozen_string_literal: true

class Internal::ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :trainer

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
    @trainee = Trainer.find(trainer_id)
  end

  def authenticate_user!
    trainer_id && sign_in || head(:unauthorized)
  end
end
