require_relative 'spec_helper'

RSpec.describe Board do
  subject(:board) { described_class.new } # similar to before(:each) do board = described_class.new end

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

  describe '#valid_coordinate?' do # checks if a given coordinate is valid
    # context is similar to describe and used to group examples. specific state/condition
    context 'when passed a valid coordinate' do
      subject(:valid) { board.valid_coordinate?('A1') }

      it { is_expected.to be true }
    end

    context 'when passed an invalid coordinate' do
      subject(:invalid) { board.valid_coordinate?('A5') }

      it { is_expected.to be false }
    end
  end

  describe '#valid_placement?' do # checks if a ship can be placed at the given coordinates
    context 'when given an invalid coordinate' do
      subject(:placement) { board.valid_placement?(submarine, %w[A4 A5]) }

      it { is_expected.to be false }
    end

    context 'when number of coordinates does not match ship length' do
      subject(:placement) { board.valid_placement?(submarine, %w[A1 A2 A3]) }

      it { is_expected.to be false }
    end

    context 'when the coordinates are not consecutive' do
      subject(:placement) { board.valid_placement?(submarine, %w[A1 A3]) }

      it { is_expected.to be false }
    end

    context 'when the coordinates are diagonal' do
      subject(:placement) { board.valid_placement?(submarine, %w[A1 B2]) }

      it { is_expected.to be false }
    end

    context 'when the coordinates already contain a ship' do # ships cannot overlap
      subject(:placement) { board.valid_placement?(submarine, %w[A1 B1]) }

      before do
        board.place(cruiser, %w[A1 A2 A3]) # cruise is placed at A1, A2, A3
      end

      it { is_expected.to be false } # so submarine cannot be placed at A1, B1
    end

    context 'when placement is valid cruiser' do # ships can be placed at valid coordinates
      subject(:placement) { board.valid_placement?(cruiser, %w[A1 A2 A3]) }

      it { is_expected.to be true }
    end

    context 'when placement is valid submarine' do
      subject(:placement) { board.valid_placement?(submarine, %w[B1 C1]) }

      it { is_expected.to be true }
    end
  end

  describe '#place' do
    context 'when given invalid placement coordinates' do
      subject(:place_ship) { board.place(cruiser, %w[A1 A2 A4]) }

      it { is_expected.to be_nil }
    end

    context 'when given valid placement coordinates' do
      it 'places a ship at the given coordinates' do # places a ship at the given coordinates
        board.place(cruiser, %w[A1 A2 A3]) # calling place method to place cruiser at A1, A2, A3

        ship_at_coords = [board.cells['A1'].ship, board.cells['A2'].ship, board.cells['A3'].ship]

        expect(ship_at_coords.all?(cruiser)).to be true # expecting the ship at each coordinate to be cruiser
      end
    end
  end
end
