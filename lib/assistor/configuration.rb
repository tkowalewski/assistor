module Assistor
  class Configuration
    attr_accessor :id, :size, :delay
    attr_reader :log_file, :pid_file

    def log_file=(file)
      @log_file = LogFile.new file
    end

    def pid_file=(file)
      @pid_file = PidFile.new file
    end
  end
end
