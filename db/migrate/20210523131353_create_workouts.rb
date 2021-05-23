# frozen_string_literal: true

class CreateWorkouts < ActiveRecord::Migration[6.1]
  def change
    create_table :workouts do |t|
      t.string :slug, unique: true, null: false
      t.references :trainer, null: false, foreign_key: true
      t.integer :state

      t.timestamps
    end
  end
end
