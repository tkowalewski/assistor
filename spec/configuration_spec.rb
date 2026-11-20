# frozen_string_literal: true

require 'spec_helper'

describe Assistor::Configuration do
  subject(:configuration) { described_class.new }

  it 'wraps log and pid files' do
    dir = Dir.mktmpdir
    configuration.log_file = File.join(dir, 'a.log')
    configuration.pid_file = File.join(dir, 'a.pid')
    expect(configuration.log_file).to be_a Assistor::LogFile
    expect(configuration.pid_file).to be_a Assistor::PidFile
  end

  it 'has a no-op exception handler by default' do
    expect(configuration.exception_handler.call(StandardError.new)).to be_nil
  end

  it 'uses the given exception handler' do
    handled = nil
    configuration.exception_handler = ->(e) { handled = e }
    error = StandardError.new
    configuration.exception_handler.call(error)
    expect(handled).to be error
  end
end
