# frozen_string_literal: true

class V1::Assignment::IndexInteractor
  def initialize(trainee, start_date = nil, end_date = nil)
    @trainee = trainee
    @start_date = start_date
    @end_date = end_date
  end

  def assignments
    @assignments = scope

    @assignments = @assignments.where("created_at >= ?", parsed_start_date) if start_date && parsed_start_date
    @assignments = @assignments.where("created_at <= ?", parsed_end_date) if end_date && parsed_end_date

    @assignments
  end

  private

  attr_reader :trainee, :start_date, :end_date

  def scope
    trainee.assignments
  end

  def parsed_start_date
    @parsed_start_date ||=
      begin
        Date.parse(start_date).beginning_of_day
      rescue Date::Error
        nil
      end
  end

  def parsed_end_date
    @parsed_end_date ||=
      begin
        Date.parse(end_date).end_of_day
      rescue Date::Error
        nil
      end
  end
end
