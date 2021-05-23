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
FactoryBot.define do
  factory :workout do
    sequence(:slug) { |x| "#{trainer.first_name}_workout_#{x}" }
    trainer { create(:trainer) }
    state { "draft" }
  end
end
