# frozen_string_literal: true

# == Schema Information
#
# Table name: assignments
#
#  id              :integer          not null, primary key
#  assignable_type :string           not null
#  completed       :boolean          default(FALSE)
#  completed_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  assignable_id   :integer          not null
#  trainee_id      :integer          not null
#  trainer_id      :integer          not null
#
# Indexes
#
#  index_assignments_on_assignable  (assignable_type,assignable_id)
#  index_assignments_on_trainee_id  (trainee_id)
#  index_assignments_on_trainer_id  (trainer_id)
#
# Foreign Keys
#
#  trainee_id  (trainee_id => trainees.id)
#  trainer_id  (trainer_id => trainers.id)
#
FactoryBot.define do
  factory :assignment do
    trainer { create(:trainer) }
    trainee { create(:trainee) }
    completed { false }
    completed_at { nil }
    assignable { create(:workout, trainer: trainer) }
  end
end
