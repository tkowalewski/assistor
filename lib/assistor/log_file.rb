module Assistor
  class LogFile
    extend Forwardable

    def_delegators :@logger, :debug, :error, :fatal, :info, :unknown, :warn

    def initialize(log_file)
      @log_file = log_file
      @logger = Logger.new(log_file)
    end

    def reopen
      $stderr.reopen @log_file, 'a+'
      $stdout.reopen $stderr
      $stdout.sync = $stderr.sync = true
    end
  end
end
