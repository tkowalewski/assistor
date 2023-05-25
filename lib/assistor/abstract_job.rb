module Assistor
  class AbstractJob
    def id
      @id ||= SecureRandom.uuid
    end

    def run
      raise NotImplementedError
    end
  end
end
