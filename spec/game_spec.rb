require_relative 'spec_helper'

RSpec.describe Game do
  subject(:game) { described_class.new }
  # subject will create a local variable named game that is initialized with a new instance of the Game class.
  # (:game) is the name of the variable that will be created.
  # {described_class.new} is the value that the variable will be initialized with.

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }
  end

  describe '#start' do
    it 'starts the game' do
      expect(game).to respond_to(:start)
    end
  end

  describe '#play_turn' do
    it 'plays a turn' do
      expect(game).to respond_to(:play_turn)
    end
  end

  describe '#game_over?' do
    it 'checks if the game is over' do
      expect(game).to respond_to(:game_over?)
    end
  end
end

