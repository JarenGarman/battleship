require_relative 'spec_helper'

RSpec.describe Ship do
  subject(:ship) { described_class.new('Cruiser', 3) }

  describe '#initialize' do
    it { is_expected.to be_instance_of(described_class) }

    it 'has a name' do
      expect(ship.name).to eq('Cruiser')
    end

    it 'has a length' do
      expect(ship.length).to eq(3)
    end

    it 'has health equal to length' do
      expect(ship.health).to eq(3)
    end

    it 'is not sunk' do
      expect(ship.sunk?).to be false
    end
  end

  describe '#hit' do
    before do
      ship.hit
    end

    it 'can hit a ship' do
      expect(ship.health).to eq(2)
    end

    it 'can sink a ship' do
      ship.hit
      ship.hit

      expect(ship.sunk?).to be true
    end
  end
end
