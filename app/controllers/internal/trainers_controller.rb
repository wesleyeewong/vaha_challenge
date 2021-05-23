# frozen_string_literal: true

class Internal::TrainersController < Internal::ApplicationController
  skip_before_action :authenticate_user!, only: %i[login]

  def login
    @trainer = Trainer.find_by(email: trainer_params[:email])

    if @trainer&.authenticate(trainer_params[:password])
      token = encode({ trainer_id: @trainer.id })
      trainer = Internal::TrainerPresenter.new(@trainer)

      render json: { trainer: trainer.to_h, token: token }
    else
      head(:unauthorized)
    end
  end

  private

  def trainer_params
    params.permit(:email, :password)
  end
end
