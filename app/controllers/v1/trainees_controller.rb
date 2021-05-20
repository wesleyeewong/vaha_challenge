# frozen_string_literal: true

class V1::TraineesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[login]

  def login
    @trainee = Trainee.find_by(email: trainee_params[:email])

    if @trainee && @trainee.authenticate(trainee_params[:password])
      token = encode({ trainee_id: @trainee.id })
      trainee = V1::TraineePresenter.new(@trainee)
      render json: { trainee: trainee.to_h, token: token }
    else
      head(:unauthorized)
    end
  end

  private

  def trainee_params
    params.permit(:email, :password)
  end
end
