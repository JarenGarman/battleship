require_relative 'spec_helper'

RSpec.describe Board do
  subject(:board) { described_class.new }

  let(:cruiser) { Ship.new('Cruiser', 3) }
  let(:submarine) { Ship.new('Submarine', 2) }

  describe '#initialize' do
    it { is_expected.to be_instance_of(described_class) }

    describe '#cells' do
      subject(:cells) { board.cells }

      it { is_expected.to be_a(Hash) }

      it 'has sixteen entries' do
        expect(cells.size).to eq(16)
      end

      it 'has values that are all Cells' do
        expect(cells.values.all?(Cell)).to be true
      end
    end
  end
end
