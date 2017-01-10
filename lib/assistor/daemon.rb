module Assistor
  class Daemon
    extend Forwardable

    def_delegators :@configuration, :id, :size, :delay, :log_file, :pid_file

    def initialize(configuration)
      @configuration = configuration
    end

    def name
      [:assistor, id].join ':'
    end

    def run(queue)
      start
      loop do
        sleep(delay) unless assist(queue)
      end
    rescue => e
      log_file.error e
    end

    private

    def start
      daemonize
      log_file.reopen
      handle_signals
      set_process_title
      pid_file.create pid
    end

    def stop
      assistant_group.wait
      assistant_group.flush
      pid_file.delete
      exit!(0)
    rescue => e
      log_file.error e
    end

    def stop!
      assistant_group.stop
      assistant_group.flush
      pid_file.delete
      exit!(1)
    rescue => e
      log_file.error e
    end

    def assist(queue)
      assistant_group.flush
      return if assistant_group.filled?
      return unless job = queue.pop

      assistant = Assistant.new(@configuration, job)
      assistant.assist

      assistant_group.add(assistant)
    rescue => e
      log_file.error e
    end

    def daemonize
      Process.daemon(true, true)
    end

    def increase
      assistant_group.increase
    end

    def decrease
      assistant_group.decrease
    end

    def set_process_title
      $0 = name
    end

    def pid
      @pid ||= Process.pid
    end

    def handle_signals
      handle_term_signal
      handle_int_signal
      handle_quit_signal
      handle_usr1_signal
      handle_usr2_signal
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

    def handle_usr1_signal
      Signal.trap('USR1') { increase }
    end

    def handle_usr2_signal
      Signal.trap('USR2') { decrease }
    end

    def assistant_group
      @assistant_group ||= AssistantGroup.new(size)
    end
  end
end
