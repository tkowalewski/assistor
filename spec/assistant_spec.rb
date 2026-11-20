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

  it 'treats a process owned by someone else as not assisting' do
    assistant = described_class.new(configuration, Assistor::AbstractJob.new)
    allow(Process).to receive(:fork).and_return(1)
    allow(Process).to receive(:detach)
    allow(Process).to receive(:kill).with(0, 1).and_raise(Errno::EPERM)
    assistant.assist
    expect(assistant.assists?).to be false
  end

  it 'rejects an insecure runtime directory' do
    allow(Dir).to receive(:tmpdir).and_return(dir)
    insecure = File.join(dir, "assistor-#{Process.uid}")
    Dir.mkdir(insecure, 0o777)
    File.chmod(0o777, insecure)
    assistant = described_class.new(configuration, Assistor::AbstractJob.new)
    expect { assistant.send(:pid_file) }.to raise_error(SecurityError)
  end
end
