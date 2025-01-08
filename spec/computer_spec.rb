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

  describe '#guess_shot' do
    let(:board) { Board.new }

    it 'can take a random shot' do
      expect(board.valid_coordinate?(computer.guess_shot(board))).to be true
    end

    it 'can hunt a ship' do
      board.place(submarine, %w[B2 C2])
      board.cells['B2'].fire_upon

      expect(%w[A2 B1 B3 C2].include?(computer.guess_shot(board))).to be true
    end
  end
end
