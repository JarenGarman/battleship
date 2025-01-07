require_relative 'spec_helper'

RSpec.describe Computer do
  subject(:computer) { described_class.new }

  let(:cruiser) { Ship.new('Cruiser', 3) }
  let(:submarine) { Ship.new('Submarine', 2) }
  let(:ships) { [cruiser, submarine] }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'has a board' do
      expect(computer.board).to be_instance_of Board
    end

    it 'has no ships' do
      expect(computer.ships).to eq([])
    end

    it 'has no targets' do
      expect(computer.targets).to eq([])
    end
  end

  describe '#add_ships' do
    it 'can add ships' do
      computer.add_ships(ships)

      expect(computer.ships).to eq([cruiser, submarine])
    end
  end

  describe '#place_ships' do
    it 'places submarine and cruiser' do
      computer.add_ships(ships)
      computer.place_ships

      expect(computer.board.render(true).count('S')).to eq(5)
    end
  end

  describe '#hunt_target' do
    it 'returns a random guess when there are no targets' do
      guess = computer.hunt_target
      expect(guess[0]).to be_between(0, computer.board.rows.length - 1)
      expect(guess[1]).to be_between(0, computer.board.columns.length - 1)
    end

    it 'returns the last target when targets are available' do
      computer.instance_variable_set(:@targets, [[1, 1], [2, 2]])
      expect(computer.hunt_target).to eq([2, 2])
    end

    it 'adds adjacent cells to targets when a ship is hit' do
      computer.add_ships([cruiser])
      computer.place_ships
      computer.instance_variable_set(:@targets, [[1, 1]])
      cell = computer.board.cells["B2"]
      cell.place_ship(cruiser)
      cell.fire_upon
      computer.hunt_target
      expect(computer.targets).to include([2, 1], [1, 2], [0, 1], [1, 0])
    end
  end

  describe '#guess_random' do
    it 'returns a random coordinate within the board' do
      guess = computer.send(:guess_random)
      expect(guess[0]).to be_between(0, computer.board.rows.length - 1)
      expect(guess[1]).to be_between(0, computer.board.columns.length - 1)
    end
  end
end
