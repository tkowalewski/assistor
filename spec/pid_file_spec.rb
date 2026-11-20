# frozen_string_literal: true

require 'spec_helper'

describe Assistor::PidFile do
  let(:path) { File.join(Dir.mktmpdir, 'test.pid') }
  subject(:pid_file) { described_class.new(path) }

  it 'creates, detects and deletes the file' do
    expect(pid_file.exist?).to be false
    pid_file.create(123)
    expect(pid_file.exist?).to be true
    expect(File.read(path)).to eq '123'
    pid_file.delete
    expect(pid_file.exist?).to be false
  end
end
