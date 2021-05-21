# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!

  attr_reader :trainee

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
        token = auth_header.split(" ")[1]

        begin
          JWT.decode(token, nil, false)
        rescue JWT::DecodeError
        end
      end
  end

  def trainee_id
    decoded_token[0]["trainee_id"]
  end

  def sign_in
    @trainee = Trainee.find_by(id: trainee_id)
  end

  def authenticate_user!
    trainee_id && sign_in || head(:unauthorized)
  end
end
