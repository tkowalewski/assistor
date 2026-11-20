# frozen_string_literal: true

module Assistor
  class AbstractQueue
    def pop
      raise NotImplementedError
    end
  end
end
