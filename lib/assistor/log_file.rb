# frozen_string_literal: true

module Assistor
  class LogFile
    extend Forwardable

    def_delegators :@logger, :debug, :error, :fatal, :info, :unknown, :warn

    def initialize(log_file)
      @log_file = log_file
      create_private_file
      @logger = Logger.new(log_file)
    end

    def reopen
      $stderr.reopen @log_file, 'a+'
      $stdout.reopen $stderr
      $stdout.sync = $stderr.sync = true
    end

    private

    def create_private_file
      flags = File::WRONLY | File::APPEND | File::CREAT | File::NOFOLLOW
      File.open(@log_file, flags, 0o600) { nil }
    end
  end
end
