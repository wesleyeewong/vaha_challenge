# frozen_string_literal: true

class Internal::AssignmentsController < Internal::ApplicationController
  def create
    trainee = trainer.trainees.find(trainee_id)
    create_interactor = Internal::Assignment::CreateInteractor.new(trainer, trainee, create_assignment_params)

    if create_interactor.call
      assignment = Internal::AssignmentPresenter.new(create_interactor.assignment, create_interactor.assignable)

      render json: assignment.to_h, status: :created
    else
      render json: { errors: create_interactor.errors.messages }, status: :unprocessable_entity
    end
  end

  private

  def trainer_id
    params[:trainer_id].to_i
  end

  def trainee_id
    params[:trainee_id].to_i
  end

  def create_assignment_params
    params.require(:assignment).permit(:type, :id)
  end
end
