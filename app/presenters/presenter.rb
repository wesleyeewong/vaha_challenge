# frozen_string_literal: true

require "delegate"

class Presenter < SimpleDelegator
  alias object __getobj__
end
