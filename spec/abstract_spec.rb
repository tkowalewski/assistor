# frozen_string_literal: true

require 'spec_helper'

describe Assistor::AbstractJob do
  it 'has a stable unique id' do
    job = described_class.new
    expect(job.id).to eq job.id
    expect(job.id).not_to eq described_class.new.id
  end

  it 'requires run to be implemented' do
    expect { described_class.new.run }.to raise_error(NotImplementedError)
  end
end

describe Assistor::AbstractQueue do
  it 'requires pop to be implemented' do
    expect { described_class.new.pop }.to raise_error(NotImplementedError)
  end
end
