# frozen_string_literal: true

class CreateWorkoutExercises < ActiveRecord::Migration[6.1]
  def change
    create_table :workout_exercises do |t|
      t.references :workout, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :order
      t.integer :duration

      t.timestamps
    end
  end
end
