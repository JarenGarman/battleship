require 'spec_helper'

RSpec.describe Game do
  subject(:game) { described_class.new }

  describe '#start' do #testing only public method for game class
    it 'starts the game' do
      expect(game).to respond_to(:start) 
    end
  end
end