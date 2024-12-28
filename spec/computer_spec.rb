require_relative 'spec_helper'

RSpec.describe Computer do
  subject(:computer) { described_class.new }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'has a board' do
      expect(computer.board).to be_instance_of Board
    end

    it 'places submarine and cruiser' do
      expect(computer.board.render(true).count('S')).to eq(5)
    end
  end
end