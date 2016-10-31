module Assistor
  class AssistantGroup
    attr_reader :size

    def initialize(size)
      @size = size
      @assistants = []
    end

    def add(assistant)
      @assistants << assistant
    end

    def flush
      @assistants.delete_if { |assistant| !assistant.assists? }
    end

    def filled?
      @assistants.size >= size
    end

    def wait
      @assistants.each do |assistant|
        begin
          Process.wait(assistant.pid)
        rescue Errno::ECHILD
          next
        end
      end
    end

    def stop
      @assistants.each do |assistant|
        begin
          Process.kill(:INT, assistant.pid)
        rescue Errno::ESRCH
          next
        end
      end
    end

    def increase
      @size += 1
    end

    def decrease
      @size -= 1
    end
  end
end
