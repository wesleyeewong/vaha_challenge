# frozen_string_literal: true

class Internal::Assignment::CreateInteractor
  include ActiveModel::Model

  attr_reader :trainer, :trainee, :assignment

  validate :assignables

  def initialize(trainer, trainee, assignment_params)
    @trainer = trainer
    @trainee = trainee
    @assignable_type = assignment_params[:type]
    @assignable_id = assignment_params[:id]
  end

  def call
    return false if invalid?

    Assignment.transaction do
      @assignment = Assignment.create(trainer: trainer, trainee: trainee, assignable: assignable)
    end

    true
  end

  private

  attr_reader :assignable_type, :assignable_id, :assignable

  def assignables
    if Assignment::TYPES.include?(assignable_type)
      errors.add(:assignable_id, :blank) unless assignable_id
      unless (@assignable = assignable_type.constantize.find_by(trainer: trainer, id: assignable_id))
        errors.add(:assignable, :not_found, message: "#{assignable_type} not found")
      end
    else
      errors.add(:assignable_type, :invalid)
    end
  end
end
