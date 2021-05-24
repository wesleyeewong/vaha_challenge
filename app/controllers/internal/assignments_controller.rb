# frozen_string_literal: true

class Internal::AssignmentsController < Internal::ApplicationController
  def create
    trainee = trainer.trainees.find(trainee_id)
    create_interactor = Internal::Assignment::CreateInteractor.new(trainer, trainee, create_assignment_params)

    if create_interactor.call
      head(:created)
    else
      render json: { errors: create_interactor.errors.message }, status: :unprocessable_entity
    end
  end

  private

  def trainer_id
    params[:trainer_id]
  end

  def trainee_id
    params[:trainee_id]
  end

  def create_assignment_params
    params.require(:assignment).permit(:type, :id)
  end
end
