# frozen_string_literal: true

# == Schema Information
#
# Table name: workouts
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  trainer_id :integer          not null
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Workout < ApplicationRecord
  belongs_to :trainer

  has_many :workout_exercises, -> { order(:order, :asc) }, inverse_of: :workout, dependent: :delete_all
  has_many :exercises, through: :workout_exercises

  STATES = {
    draft: 1,
    published: 2
  }.freeze

  enum state: STATES, _suffix: true
end
