require_relative 'spec_helper'

RSpec.describe Game do
  subject(:game) { described_class.new }
  # subject will create a local variable named game that is initialized with a new instance of the Game class.
  # (:game) is the name of the variable that will be created.
  # {described_class.new} is the value that the variable will be initialized with.

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }

    it 'initializes with game_over set to false' do # tests that the Game class initializes with game_over set to false
      expect(game.game_over).to be false
    end
  end
end
