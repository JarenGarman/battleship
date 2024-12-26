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

  describe '#valid_coordinate?' do
    context 'when passed a valid coordinate' do
      subject(:valid) { board.valid_coordinate?('A1') }

      it { is_expected.to be true }
    end

    context 'when passed an invalid coordinate' do
      subject(:invalid) { board.valid_coordinate?('A5') }

      it { is_expected.to be false }
    end
  end

  describe '#valid_placement?' do
    it 'returns false for non-consecutive coordinates' do
      expect(board.valid_placement?(submarine, ['A1', 'A3'])).to be false
      expect(board.valid_placement?(submarine, ['A1', 'B2'])).to be false
    end

    it 'returns false for overlapping ships' do
      board.place(cruiser, ['A1', 'A2', 'A3'])
      expect(board.valid_placement?(submarine, ['A1', 'B1'])).to be false
    end

    it 'returns true for valid placements' do
      expect(board.valid_placement?(cruiser, ['A1', 'A2', 'A3'])).to be true
      expect(board.valid_placement?(submarine, ['B1', 'C1'])).to be true
    end
  end

  describe '#place' do
    it 'places a ship at the given coordinates' do
      board.place(cruiser, ['A1', 'A2', 'A3'])
      expect(board.cells['A1'].ship).to eq(cruiser)
      expect(board.cells['A2'].ship).to eq(cruiser)
      expect(board.cells['A3'].ship).to eq(cruiser)
    end
  end
end
