# frozen_string_literal: true

class V1::PersonalClassPresenter < Presenter
  def to_h
    {
      trainer: trainer.to_h,
      trainee: trainee.to_h,
      started_at: started_at
    }
  end

  private

  def trainer
    V1::TrainerPresenter.new(object.trainer)
  end

  def trainee
    V1::TraineePresenter.new(object.trainee)
  end

  def started_at
    object.started_at.strftime("%d/%m/%Y")
  end
end
