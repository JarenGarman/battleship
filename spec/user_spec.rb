require 'spec_helper'

RSpec.describe User do
  let(:user) { described_class.new }
  let(:board) { instance_double(Board) }
  let(:cruiser) { Ship.new('Cruiser', 3) }
  let(:submarine) { Ship.new('Submarine', 2) }

  before do
    allow(Board).to receive(:new).and_return(board)
    allow(board).to receive(:render).and_return("  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n")
    allow(board).to receive(:valid_placement?).and_return(true)
    allow(board).to receive(:place)
  end

  describe '#initialize' do
    it 'initializes with a new board' do
      expect(user.board).to eq(board)
    end
  end

  describe '#place_ships' do
    before do
      allow(user).to receive(:gets).and_return('A1 A2 A3', 'B1 B2')
    end

    it 'prompts the user to place ships and displays the board' do
      expect { user.place_ships([cruiser, submarine]) }.to output(/Enter the squares for the Cruiser \(3 spaces\):\n  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\nEnter the squares for the Submarine \(2 spaces\):\n  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n/).to_stdout
      expect(board).to have_received(:place).with(cruiser, ['A1', 'A2', 'A3'])
      expect(board).to have_received(:place).with(submarine, ['B1', 'B2'])
    end
  end

  describe '#render_board' do
    it 'displays the current state of the board' do
      expect { user.render_board }.to output("  1 2 3 4\nA . . . .\nB . . . .\nC . . . .\nD . . . .\n").to_stdout
    end
  end
end