# frozen_string_literal: true

require 'spec_helper'

describe Assistor::AssistantGroup do
  subject(:group) { described_class.new(2) }

  let(:alive) { instance_double(Assistor::Assistant, assists?: true, pid: 1) }
  let(:dead) { instance_double(Assistor::Assistant, assists?: false, pid: 2) }

  it 'is filled once size is reached' do
    group.add(alive)
    expect(group).not_to be_filled
    group.add(alive)
    expect(group).to be_filled
  end

  it 'flushes finished assistants' do
    group.add(alive)
    group.add(dead)
    group.flush
    group.add(alive)
    expect(group).to be_filled
  end

  it 'increases and decreases size but not below zero' do
    group.increase
    expect(group.size).to eq 3
    4.times { group.decrease }
    expect(group.size).to eq 0
  end

  it 'ignores missing processes on stop and wait' do
    allow(Process).to receive(:kill).and_raise(Errno::ESRCH)
    allow(Process).to receive(:wait).and_raise(Errno::ECHILD)
    group.add(alive)
    expect { group.stop }.not_to raise_error
    expect { group.wait }.not_to raise_error
  end
end
