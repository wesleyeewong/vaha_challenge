# frozen_string_literal: true

class V1::PersonalClassesController < ApplicationController
  def create
    trainee.personal_class.destroy if trainee.personal_class?

    if (@personal_class = trainer.personal_classes.create!(trainee: trainee, started_at: Time.current))
      personal_class = V1::PersonalClassPresenter.new(@personal_class)
      render json: { personal_class: personal_class.to_h }, status: :created
    else
      head(:forbidden)
    end
  end

  def destroy
    trainee.personal_class.destroy if trainee.personal_class?

    head(:no_content)
  end

  private

  def trainer
    @trainer ||= Trainer.find(params[:trainer_id])
  end
end
