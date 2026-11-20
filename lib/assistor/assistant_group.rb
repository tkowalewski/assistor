# frozen_string_literal: true

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
        Process.wait(assistant.pid)
      rescue Errno::ECHILD
        next
      end
    end

    def stop
      @assistants.each do |assistant|
        Process.kill(:INT, assistant.pid)
      rescue Errno::ESRCH
        next
      end
    end

    def increase
      @size += 1
    end

    def decrease
      @size -= 1 if @size.positive?
    end
  end
end
