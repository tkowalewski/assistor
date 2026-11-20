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

  it 'creates the file readable only by the owner' do
    pid_file.create(1)
    expect(File.stat(path).mode & 0o777).to eq 0o600
  end

  it 'refuses to write through a symlink' do
    target = File.join(File.dirname(path), 'target')
    File.write(target, 'keep')
    File.symlink(target, path)
    expect { pid_file.create(1) }.to raise_error(SystemCallError)
    expect(File.read(target)).to eq 'keep'
  end

  it 'ignores deleting a missing file' do
    expect { pid_file.delete }.not_to raise_error
  end
end
