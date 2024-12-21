require 'spec_helper'

RSpec.describe Ship do
  subject { described_class.new("Cruiser", 3) }

  describe '#initialize' do
    it 'exists' do
      expect(subject).to be_instance_of(Ship)
    end

    it 'has a name' do
      expect(subject.name).to eq("Cruiser")
    end

    it 'has a length' do
      expect(subject.length).to eq(3)
    end
  end
end
