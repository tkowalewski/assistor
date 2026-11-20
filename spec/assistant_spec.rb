# frozen_string_literal: true

require 'spec_helper'

describe Assistor::Assistant do
  let(:dir) { Dir.mktmpdir }
  let(:configuration) do
    Assistor::Configuration.new.tap do |c|
      c.id = 'test'
      c.log_file = File.join(dir, 'test.log')
    end
  end
  let(:out) { File.join(dir, 'out') }

  def wait_until(timeout: 5)
    deadline = Time.now + timeout
    sleep 0.05 until yield || Time.now > deadline
  end

  it 'runs the job in a forked process' do
    job_out = out
    job = Class.new(Assistor::AbstractJob) do
      define_method(:run) { File.write(job_out, Process.pid.to_s) }
    end.new
    assistant = described_class.new(configuration, job)
    assistant.assist
    wait_until { !assistant.assists? }
    expect(File.read(out)).to eq assistant.pid.to_s
    expect(assistant.pid).not_to eq Process.pid
    expect(assistant.name).to eq "assistor:test:#{job.id}"
  end

  it 'reports job exceptions to the exception handler' do
    handled = File.join(dir, 'handled')
    configuration.exception_handler = ->(e) { File.write(handled, e.message) }
    job = Class.new(Assistor::AbstractJob) do
      def run = raise('boom')
    end.new
    assistant = described_class.new(configuration, job)
    assistant.assist
    wait_until { File.exist?(handled) }
    expect(File.read(handled)).to eq 'boom'
  end
end
