# frozen_string_literal: true

# == Schema Information
#
# Table name: exercises
#
#  id         :integer          not null, primary key
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Exercise < ApplicationRecord
  has_many :workout_exercises, dependent: :delete_all
end
