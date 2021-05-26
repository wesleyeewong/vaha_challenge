# frozen_string_literal: true

class V1::WorkoutPresenter < Presenter
  def to_h
    {
      exercises: workout_exercises.map(&:to_h),
      total_duration: total_duration,
      id: id
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
