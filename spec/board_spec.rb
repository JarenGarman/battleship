require_relative 'spec_helper'

RSpec.describe Board do
  subject(:board) { described_class.new } #similar to before(:each) do board = described_class.new end

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

  describe '#valid_coordinate?' do #checks if a given coordinate is valid
    context 'when passed a valid coordinate' do #context is similar to describe and used to group examples. specific state/condition
      subject(:valid) { board.valid_coordinate?('A1') }

      it { is_expected.to be true }
    end

    context 'when passed an invalid coordinate' do 
      subject(:invalid) { board.valid_coordinate?('A5') }

      it { is_expected.to be false }
    end
  end

  describe '#valid_placement?' do #checks if a ship can be placed at the given coordinates
    it 'returns false for non-consecutive coordinates' do
      expect(board.valid_placement?(submarine, %w[A1 A3])).to be false #%w is a shortcut for creating an array of strings - range is better for consecutive numbers
      expect(board.valid_placement?(submarine, %w[A1 B2])).to be false #diagnoal coordinates are not allowed
    end

    it 'returns false for overlapping ships' do #ships cannot overlap
      board.place(cruiser, %w[A1 A2 A3]) #cruise is placed at A1, A2, A3
      expect(board.valid_placement?(submarine, %w[A1 B1])).to be false #so submarine cannot be placed at A1, B1
    end

    it 'returns true for valid placements' do #ships can be placed at valid coordinates
      expect(board.valid_placement?(cruiser, %w[A1 A2 A3])).to be true 
      expect(board.valid_placement?(submarine, %w[B1 C1])).to be true 
    end
  end

  describe '#place' do
    it 'places a ship at the given coordinates' do #places a ship at the given coordinates
      board.place(cruiser, %w[A1 A2 A3]) #calling place method to place cruiser at A1, A2, A3
      expect(board.cells['A1'].ship).to eq(cruiser) #expecting the ship at A1 to be cruiser
      expect(board.cells['A2'].ship).to eq(cruiser)
      expect(board.cells['A3'].ship).to eq(cruiser)
    end
  end
end
