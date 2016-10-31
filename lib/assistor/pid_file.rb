module Assistor
  class PidFile
    def initialize(pid_file)
      @pid_file = pid_file
    end

    def create(pid)
      File.write @pid_file, pid
    end

    def delete
      File.delete @pid_file
    end

    def exist?
      File.exist? @pid_file
    end
  end
end
