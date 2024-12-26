require_relative 'spec_helper'

RSpec.describe Cell do
  subject(:cell) { described_class.new('B4') }

  let(:cruiser) { Ship.new('Cruiser', 3) }

  describe '#initialize' do
    it { is_expected.to be_instance_of(described_class) }

    it 'has a coordinate' do # coordinate is an argument passed to the initialize method - ie "B4"
      expect(cell.coordinate).to eq('B4')
    end

    it 'is empty' do # empty? method checks if a cell is empty
      expect(cell.empty?).to be true
    end

    it 'has no ship' do
      expect(cell.ship).to be_nil
    end

    it 'is not fired upon' do # fired_upon? method returns false by default
      expect(cell.fired_upon?).to be false
    end
  end

  describe '#place_ship' do
    before do
      cell.place_ship(cruiser) # place_ship method is called on the cell object and the ship is passed as an argument
    end

    it 'can place a ship' do
      expect(cell.ship).to eq(cruiser)
    end

    it 'is no longer empty' do
      expect(cell.empty?).to be false
    end
  end

  describe '#fired_upon' do
    it 'can be fired upon' do # fire_upon method marks a cell as fired upon
      cell.fire_upon
      expect(cell.fired_upon?).to be true
    end

    it 'reduces the health of the ship' do # fire_upon method calls the hit method on the ship if the cell is not empty
      cell.place_ship(cruiser)
      cell.fire_upon
      expect(cruiser.health).to eq(2)
    end
  end

  describe '#render' do
    subject(:render) { cell.render }

    context 'when the cell has no ship' do
      context 'and the cell has not been fired upon' do
        it { is_expected.to eq('.') }
      end

      context 'and the cell has been fired upon' do
        before do
          cell.fire_upon
        end

        it { is_expected.to eq('M') }
      end
    end

    context 'when the cell has a ship' do
      before do
        cell.place_ship(cruiser)
      end

      context 'and the cell has not been fired upon' do
        context 'and debug is false' do
          it { is_expected.to eq('.') }
        end

        context 'and debug is true' do
          it 'is expected to eq "S"' do
            expect(cell.render(true)).to eq('S')
          end
        end
      end

      context 'and the cell has been fired upon' do
        before do
          cell.fire_upon
        end

        context 'and the ship is not sunk' do
          it { is_expected.to eq('H') }
        end

        context 'and the ship is sunk' do
          before do
            cruiser.hit
            cruiser.hit
          end

          it { is_expected.to eq('X') }
        end
      end
    end
  end
end
