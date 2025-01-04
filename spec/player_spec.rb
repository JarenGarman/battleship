require_relative 'spec_helper'

RSpec.describe Player do
  subject(:player) { described_class.new }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'has a board' do
      expect(player.board).to be_instance_of Board
    end

    it 'has no ships' do
      expect(player.ships).to eq([])
    end
  end

  describe '#add_ships' do
    let(:cruiser) { Ship.new('Cruiser', 3) }
    let(:submarine) { Ship.new('Submarine', 2) }
    let(:ships) { [cruiser, submarine] }

    it 'can add ships' do
      player.add_ships(ships)

      expect(player.ships).to eq([cruiser, submarine])
    end
  end
end
