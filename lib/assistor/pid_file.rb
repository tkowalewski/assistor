# frozen_string_literal: true

module Assistor
  class PidFile
    def initialize(pid_file)
      @pid_file = pid_file
    end

    def create(pid)
      flags = File::WRONLY | File::CREAT | File::TRUNC | File::NOFOLLOW
      File.open(@pid_file, flags, 0o600) { |file| file.write(pid) }
    end

    def delete
      File.delete @pid_file
    rescue Errno::ENOENT
      nil
    end

    def exist?
      File.exist? @pid_file
    end
  end
end
