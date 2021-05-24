# frozen_string_literal: true

# == Schema Information
#
# Table name: trainers
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  email           :string           not null
#  password_digest :string           not null
#  expertise       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Trainer < User
  EXPERTISE = {
    yoga: 1,
    strength: 2,
    fitness: 3
  }.freeze

  enum expertise: EXPERTISE

  has_many :personal_classes, dependent: :destroy
  has_many :trainees, through: :personal_classes
  has_many :workouts, dependent: :destroy

  # define scopes for the different workout states
  Workout::STATES.each_key do |state|
    has_many :"#{state}_workouts", -> { where(state: state) }, class_name: "Workout", inverse_of: :trainer
  end
end
