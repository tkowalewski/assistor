# frozen_string_literal: true

require 'spec_helper'

describe Assistor::Daemon do
  let(:dir) { Dir.mktmpdir }
  let(:configuration) do
    Assistor::Configuration.new.tap do |c|
      c.id = 'test'
      c.size = 1
      c.delay = 0.01
      c.log_file = File.join(dir, 'test.log')
      c.pid_file = File.join(dir, 'test.pid')
    end
  end
  let(:queue) { instance_double(Assistor::AbstractQueue) }
  let(:job) { Assistor::AbstractJob.new }

  subject(:daemon) { described_class.new(configuration) }

  it 'builds its name from the configuration id' do
    expect(daemon.name).to eq 'assistor:test'
  end

  it 'returns nil when the queue is empty' do
    allow(queue).to receive(:pop).and_return(nil)
    expect(daemon.send(:assist, queue)).to be_nil
  end

  it 'starts an assistant per job until the group is full' do
    assistant = instance_double(Assistor::Assistant, assists?: true, assist: nil)
    allow(Assistor::Assistant).to receive(:new).and_return(assistant)
    allow(queue).to receive(:pop).and_return(job)
    daemon.send(:assist, queue)
    expect(daemon.send(:assist, queue)).to be_nil
    expect(Assistor::Assistant).to have_received(:new).once
  end

  it 'passes queue errors to the exception handler' do
    handled = nil
    configuration.exception_handler = ->(e) { handled = e }
    allow(queue).to receive(:pop).and_raise('queue down')
    daemon.send(:assist, queue)
    expect(handled.message).to eq 'queue down'
  end
end
