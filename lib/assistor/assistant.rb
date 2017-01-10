module Assistor
  class Assistant
    extend Forwardable

    def_delegators :@configuration, :log_file

    attr_reader :pid

    def initialize(configuration, job)
      @configuration = configuration
      @job = job
    end

    def id
      @id ||= [@configuration.id, @job.id].join ':'
    end

    def name
      @name ||= [:assistor, id].join ':'
    end

    def assist
      @pid = Process.fork do
        start
        process
        stop
      end
      detach
    rescue => e
      log_file.error e
    end

    def assists?
      Process.kill(0, pid)
    rescue Errno::ESRCH
      false
    end

    private

    def start
      log_file.reopen
      handle_signals
      set_process_title
    end

    def process
      with_pid_file { @job.run }
    rescue => e
      log_file.error e
      @job.fail e
    end

    def stop
      return if pid_file.exist?
      exit!(0)
    rescue => e
      log_file.error e
    end

    def stop!
      pid_file.delete
      exit!(1)
    rescue => e
      log_file.error e
    end

    def handle_signals
      handle_term_signal
      handle_int_signal
      handle_quit_signal
    end

    def handle_term_signal
      Signal.trap('TERM') do
        Thread.new { stop! }.join
        exit
      end
    end

    def handle_int_signal
      Signal.trap('INT') do
        Thread.new { stop! }.join
        exit
      end
    end

    def handle_quit_signal
      Signal.trap('QUIT') do
        Thread.new { stop }.join
      end
    end

    def set_process_title
      $0 = name
    end

    def detach
      Process.detach pid
    end

    def pid_file
      @pid_file ||= PidFile.new File.join(Dir.tmpdir, format('%s.pid', Process.pid))
    end

    def with_pid_file
      pid_file.create Process.pid
      yield
      pid_file.delete
    end
  end
end
