# frozen_string_literal: true

class Internal::WorkoutExercisePresenter < Presenter
  def to_h
    {
      slug: exercise.slug,
      duration: duration,
      order: order
    }
  end
end
