# frozen_string_literal: true

class Internal::TrainerPresenter < Presenter
  def to_h
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      expertise: expertise,
      trainees: trainees.map(&:to_h)
    }
  end

  private

  def trainees
    V1::TraineePresenter.wrap(object.trainees)
  end
end
