# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments do |t|
      t.references :trainer, null: false, foreign_key: true
      t.references :trainee, null: false, foreign_key: true
      t.boolean :completed, default: false
      t.datetime :completed_at
      t.references :assignable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
