# frozen_string_literal: true

class Internal::Workout::CreateInteractor
  include ActiveModel::Model

  attr_reader :trainer, :workout

  validate :workout_params_data_type

  def initialize(trainer, workout_params)
    @trainer = trainer
    @workout_params = workout_params
  end

  def call
    return false if invalid?

    Workout.transaction do
      @workout = Workout.create(trainer: trainer, slug: workout_slug, state: workout_state)

      workout_exercises = workout_params[:exercises].map.with_index(1) do |workout_exercise, order|
        exercise_slug = workout_exercise[:slug]
        duration = workout_exercise[:duration]
        { exercise: exercises.find_by(slug: exercise_slug), order: order, duration: duration }
      end

      @workout.workout_exercises.create(workout_exercises)
    end

    true
  end

  private

  attr_reader :workout_params, :exercise_slugs, :workout_slug, :durations

  def exercises
    @exercises ||= Exercise.where(slug: exercise_slugs)
  end

  def workout_state
    @workout_state ||= "draft"
  end

  def workout_params_data_type
    @exercise_slugs = []
    @durations = []
    invalid_durations = []

    workout_params[:exercises].each do |workout_exercise|
      slug = workout_exercise[:slug]
      duration = workout_exercise[:duration]

      @exercise_slugs << slug
      @durations << duration
      invalid_durations << duration if !duration.is_a?(Integer) || !duration.positive?
    end

    @exercise_slugs.uniq!

    # validate durations
    if invalid_durations.present?
      errors.add(:durations, :invalid,
                 message: "Durations: #{invalid_durations} aren't valid")
    end

    # validate state
    if (@workout_state = workout_params[:state]&.to_sym) && !Workout::STATES.key?(@workout_state)
      errors.add(:workout_state, :invalid, message: "#{@workout_state} is not a valid state")
    end

    # validate exercise exists
    if exercise_slugs.size > exercises.size
      invalid_exercises = exercise_slugs - exercises.pluck(:slug)

      errors.add(:exercise_slugs, :invalid, message: "#{invalid_exercises} exercises are invalid")
    end

    if (@workout_slug = workout_params[:slug]&.downcase&.tr(" _", "-")) &&
       trainer.workouts.pluck(:slug).include?(@workout_slug)
      errors.add(:workout_slug, :taken)
    elsif @workout_slug.nil?
      errors.add(:workout_slug, :blank)
    end
  end
end
