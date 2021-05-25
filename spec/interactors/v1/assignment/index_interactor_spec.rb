# frozen_string_literal: true

require "rails_helper"

RSpec.describe V1::Assignment::IndexInteractor do
  let(:trainee) { create(:trainee) }
  let(:trainer) { create(:trainer) }
  let(:start_date) { nil }
  let(:end_date) { nil }
  let(:interactor) { described_class.new(trainee, start_date, end_date) }

  describe "#assignments" do
    subject(:assignments) { interactor.assignments }

    context "when no dates passed in" do
      it "returns all trainee assignments" do
        2.times { create(:assignment, trainer: trainer, trainee: trainee) }

        expect(assignments.size).to eq(2)
      end

      context "when trainee has no assignments" do
        it "returns empty assignment" do
          expect(assignments.size).to eq(0)
        end
      end
    end

    context "when start date passed in" do
      let(:start_date) { "01/11/2021" }

      it "filters based on start date" do
        parsed_date = DateTime.parse(start_date)

        # included
        assignment = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date)

        # excluded
        create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date - 1.day)

        expect(assignments.size).to eq(1)
        expect(assignments.first).to eq(assignment)
      end

      context "when start date is not valid" do
        let(:start_date) { "Georgia" }

        it "does not filter by start date" do
          parsed_date = DateTime.parse("01/11/2021")

          create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date)
          create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date - 1.day)

          expect(assignments.size).to eq(2)
        end
      end
    end

    context "when end date paseed in" do
      let(:end_date) { "01/11/2021" }

      it "filters based on end date" do
        parsed_date = DateTime.parse(end_date)

        # included
        assignment = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date)

        # excluded
        create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date + 1.day)

        expect(assignments.size).to eq(1)
        expect(assignments.first).to eq(assignment)
      end

      context "when end date is not valid" do
        let(:end_date) { "Georgia" }

        it "does not filter by end date" do
          parsed_date = DateTime.parse("01/11/2021")

          create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date)
          create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_date + 1.day)

          expect(assignments.size).to eq(2)
        end
      end
    end

    context "when both start and end date passed in" do
      let(:start_date) { "01/11/2021" }
      let(:end_date) { "05/11/2021" }

      it "fitlers based on start and end date" do
        parsed_start_date = DateTime.parse(start_date)
        parsed_end_date = DateTime.parse(end_date)

        # included
        assignment1 = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_start_date)
        assignment2 = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_start_date + 1.day)
        assignment3 = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_end_date)
        assignment4 = create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_end_date - 1.day)

        # excluded
        create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_start_date - 1.day)
        create(:assignment, trainer: trainer, trainee: trainee, created_at: parsed_end_date + 1.day)

        expected_ids = [assignment1.id, assignment2.id, assignment3.id, assignment4.id]

        expect(assignments.size).to eq(4)
        expect(assignments.pluck(:id)).to match_array(expected_ids)
      end
    end
  end
end
