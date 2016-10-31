module Assistor
  class AbstractJob
    def id
      @id ||= SecureRandom.uuid
    end

    def run
      raise NotImplementedError
    end

    def fail(exception)
      raise NotImplementedError
    end
  end
end
