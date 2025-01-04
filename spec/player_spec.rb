require_relative 'spec_helper'

RSpec.describe Player do
  subject(:player) { described_class.new }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'initializes with a new board' do
      expect(player.board).to be_instance_of Board
    end
  end
end
