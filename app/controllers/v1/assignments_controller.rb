# frozen_string_literal: true

class V1::AssignmentsController < ApplicationController
  def index
    @assignments = trainee.assignments

    assignments = V1::AssignmentPresenter.wrap(@assignments)

    render json: { assignments: assignments.map(&:to_h) }, status: :ok
  end

  def show
    @assignment = trainee.assignments.find(assignment_id)
    assignable_type = @assignment.assignable_type
    assignable_id = @assignment.assignable_id
    assignable = assignable_type.camelize.constantize.find(assignable_id)
    assignment = V1::AssignmentPresenter.new(@assignment, assignable)

    render json: { assignment: assignment.to_h }, status: :ok
  end

  private

  def assignment_id
    params[:id]
  end
end