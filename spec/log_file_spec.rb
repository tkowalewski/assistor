# frozen_string_literal: true

require 'spec_helper'

describe Assistor::LogFile do
  it 'creates the log readable only by the owner' do
    path = File.join(Dir.mktmpdir, 'test.log')
    described_class.new(path)
    expect(File.stat(path).mode & 0o777).to eq 0o600
  end
end
