# frozen_string_literal: true

class Internal::WorkoutsController < Internal::ApplicationController
  def create
    create_interactor = Internal::Workout::CreateInteractor.new(trainer, create_workout_params)

    if create_interactor.call
      workout = Internal::WorkoutPresenter.new(create_interactor.workout)

      render json: { workout: workout.to_h }, status: :created
    else
      render json: { errors: create_interactor.errors.messages }, status: :unprocessable_entity
    end
  end

  def update
    update_interactor = Internal::Workout::UpdateInteractor.new(trainer, workout_id, update_workout_params)

    if update_interactor.call
      workout = Internal::WorkoutPresenter.new(update_interactor.workout)

      render json: { workout: workout.to_h }, status: :ok
    else
      render json: { errors: update_interactor.errors.messages }, status: :unprocessablle_entity
    end
  end

  def destroy
    workout = trainer.workouts.find(workout_id)

    workout.destroy

    head(:no_content)
  end

  def index
    @workouts = trainer.workouts
    workouts = Internal::WorkoutPresenter.wrap(@workouts)

    render json: { workouts: workouts.map(&:to_h) }
  end

  def show
    @workout = trainer.workouts.find(workout_id)
    workout = Internal::WorkoutPresenter.new(@workout)

    render json: { workout: workout.to_h }
  end

  private

  def workout_id
    params[:workout_id].to_i
  end

  def create_workout_params
    params.require(:workout).permit(
      :slug,
      :state,
      exercises: %i[slug duration]
    )
  end

  def update_workout_params
    params.require(:workout).permit(
      :slug,
      :state,
      exercises: %i[slug duration]
    )
  end
end
