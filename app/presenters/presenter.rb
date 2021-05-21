# frozen_string_literal: true

require "delegate"

class Presenter < SimpleDelegator
  alias object __getobj__

  def self.wrap(collection)
    collection.map { |member| new(member) }
  end
end
