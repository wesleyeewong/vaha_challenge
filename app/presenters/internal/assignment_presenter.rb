# frozen_string_literal: true

class Internal::AssignmentPresenter < Presenter
  attr_reader :assignable

  def initialize(assignment, assignable)
    super(assignment)

    @assignable = assignable
  end

  def to_h
    {
      assigned_by: trainer.full_name,
      assignment_type: assignable_type,
      assignment: assignment.to_h,
      id: id
    }
  end

  private

  def assignment
    case assignable_type
    when "Workout"
      Internal::WorkoutPresenter.new(assignable)
    end
  end
end
