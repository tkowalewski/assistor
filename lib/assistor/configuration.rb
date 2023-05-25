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

    def exception_handler(exception_handler)
      @exception_handler = exception_handler
    end

    def exception_handler
      @exception_handler || Proc.new {}
    end
  end
end
