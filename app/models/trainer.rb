# frozen_string_literal: true

# == Schema Information
#
# Table name: trainers
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  expertise  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Trainer < User
  EXPERTISE = {
    yoga: 1,
    strength: 2,
    fitness: 3
  }.freeze

  enum exertise: EXPERTISE
end
