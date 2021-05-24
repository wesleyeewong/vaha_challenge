# frozen_string_literal: true

class Internal::TraineesController < Internal::ApplicationController
  def index
    @trainees = trainer.trainees
    trainees = V1::TraineePresenter.wrap(@trainees)

    render json: { trainees: trainees.map(&:to_h) }
  end

  def show
    @trainee = trainer.trainees.find(trainee_id)
    trainee = V1::TraineePresenter.new(@trainee)

    render json: { trainee: trainee.to_h }
  end

  private

  def trainee_id
    params[:id]
  end
end
