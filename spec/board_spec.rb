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

    it 'has 4 rows' do
      expect(board.rows.length).to eq(4)
    end

    it 'has 4 columns' do
      expect(board.columns.length).to eq(4)
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

    context 'when placement is valid cruiser with coords out of order' do
      subject(:placement) { board.valid_placement?(cruiser, %w[A2 A3 A1]) }

      it { is_expected.to be true }
    end

    context 'when placement is valid submarine' do
      subject(:placement) { board.valid_placement?(submarine, %w[B1 C1]) }

      it { is_expected.to be true }
    end

    context 'when placement is valid submarine with coords out of order' do
      subject(:placement) { board.valid_placement?(submarine, %w[C1 B1]) }

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

  describe '#render' do
    subject(:render) { board.render }

    context 'when no ships have been placed' do
      it 'renders an empty board' do
        expect(render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
      end
    end

    context 'when a ship has been placed' do
      before do
        board.place(cruiser, %w[A1 A2 A3])
      end

      context 'when debug is false' do
        it 'renders an empty board' do
          expect(render).to eq("  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n")
        end
      end

      context 'when debug is true' do
        subject(:render) { board.render(true) }

        context 'when the ship has not been hit' do
          it 'renders the board with the ship' do
            expect(render).to eq("  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n")
          end
        end

        context 'when the ship has been hit' do
          before do
            board.cells['A1'].fire_upon
          end

          it 'can render a hit' do
            expect(render).to eq("  1 2 3 4 \nA H S S . \nB . . . . \nC . . . . \nD . . . . \n")
          end
        end

        context 'when the ship has been sunk' do
          before do
            board.cells['A1'].fire_upon
            board.cells['A2'].fire_upon
            board.cells['A3'].fire_upon
          end

          it 'can render a sunken ship' do
            expect(render).to eq("  1 2 3 4 \nA X X X . \nB . . . . \nC . . . . \nD . . . . \n")
          end
        end

        context 'when a shot misses' do
          before do
            board.cells['A4'].fire_upon
          end

          it 'can render a missed shot' do
            expect(render).to eq("  1 2 3 4 \nA S S S M \nB . . . . \nC . . . . \nD . . . . \n")
          end
        end
      end
    end
  end
end
