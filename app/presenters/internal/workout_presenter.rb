# frozen_string_literal: true

class Internal::WorkoutPresenter < Presenter
  def to_h
    {
      exercises: workout_exercises.map(&:to_h),
      total_duration: total_duration,
      state: state
    }
  end

  private

  def workout_exercises
    Internal::WorkoutExercisePresenter.wrap(object.workout_exercises)
  end

  def total_duration
    object.workout_exercises.sum(:duration)
  end
end
