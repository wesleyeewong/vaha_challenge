# frozen_string_literal: true

class V1::AssignmentPresenter < Presenter
  attr_reader :assignable

  def initialize(assignment, assignable = nil)
    super(assignment)

    @assignable = assignable
  end

  def to_h
    hash = {
      assigned_by: trainer.full_name,
      assignment_type: assignable_type,
      completed: completed,
      assigned_at: assigned_at
    }

    hash[:assignment] = assignment.to_h unless assignable.nil?

    hash
  end

  private

  def assignment
    case assignable_type
    when "Workout"
      V1::WorkoutPresenter.new(assignable)
    end
  end

  def assigned_at
    created_at.strftime("%d/%m/%Y")
  end
end
