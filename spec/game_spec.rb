require 'spec_helper'
require_relative '../lib/game'

RSpec.describe Game do
  let(:game) { described_class.new }

  describe '#initialize' do
    it 'initializes with game_over set to false' do
      expect(game.instance_variable_get(:@game_over)).to eq(false)
    end
  end

  describe '#display_main_menu' do
    before do
      allow(game).to receive(:gets).and_return('q')
    end

    it 'displays the main menu' do
      expect { game.display_main_menu }.to output("Welcome to BATTLESHIP\nEnter 'p' to play. Enter 'q' to quit.\n").to_stdout
    end
  end

  describe '#handle_main_menu_input' do
    before do
      allow(game).to receive(:gets).and.return(input)
    end

    context "when input is 'p'" do
      let(:input) { 'p' }

      it 'starts the game' do
        expect(game).to receive(:start_game)
        game.send(:handle_main_menu_input)
      end
    end

    context "when input is 'q'" do
      let(:input) { 'q' }

      it 'quits the game' do
        expect { game.send(:handle_main_menu_input) }.to output(/Quitting game.../).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when input is invalid" do
      let(:input) { 'invalid' }

      it 'displays an invalid input message and redisplays the main menu' do
        expect(game).to receive(:display_main_menu).twice
        expect { game.send(:handle_main_menu_input) }.to output(/Invalid input/).to_stdout
      end
    end
  end

  describe '#start_game' do
    it 'calls setup_game, play_game, and end_game' do
      expect(game).to receive(:setup_game)
      expect(game).to receive(:play_game)
      expect(game).to receive(:end_game)
      game.start_game
    end
  end

  describe '#setup_game' do
    it 'sets up ships for player and computer' do
      player = instance_double(Player)
      computer = instance_double(Player)
      allow(Player).to receive(:new).and.return(player, computer)
      expect(player).to receive(:setup_ships)
      expect(computer).to receive(:setup_ships)
      game.setup_game
    end
  end

  describe '#play_game' do
    it 'alternates turns between player and computer until game is over' do
      allow(game).to receive(:game_over).and.return(false, false, true)
      expect(game).to receive(:player_turn).ordered
      expect(game).to receive(:computer_turn).ordered
      game.send(:play_game)
    end
  end

  describe '#check_game_over' do
    let(:player_board) { instance_double(Board) }
    let(:computer_board) { instance_double(Board) }

    before do
      game.instance_variable_set(:@player_board, player_board)
      game.instance_variable_set(:@computer_board, computer_board)
    end

    context 'when player board has all ships sunk' do
      it 'sets game_over to true and displays loss message' do
        allow(player_board).to receive(:all_ships_sunk?).and.return(true)
        expect { game.send(:check_game_over) }.to output(/You lost!/).to_stdout
        expect(game.instance_variable_get(:@game_over)).to eq(true)
      end
    end

    context 'when computer board has all ships sunk' do
      it 'sets game_over to true and displays win message' do
        allow(computer_board).to receive(:all_ships_sunk?).and.return(true)
        expect { game.send(:check_game_over) }.to output(/You won!/).to_stdout
        expect(game.instance_variable_get(:@game_over)).to eq(true)
      end
    end
  end

  describe '#end_game' do
    it 'displays game over message and returns to main menu' do
      expect(game).to receive(:display_main_menu)
      expect { game.send(:end_game) }.to output(/Game over. Returning to main menu.../).to_stdout
    end
  end
end



# Explanation
# Initialization: Tests that the Game class initializes with game_over set to false.
# Start Game: Tests that the start_game method calls setup_game, play_game, and end_game.
# Setup Game: Tests that the setup_game method sets up ships for both the player and the computer.
# Play Game: Tests that the play_game method alternates turns between the player and the computer until the game is over.
# Check Game Over: Tests that the check_game_over method correctly sets the game over state and displays the appropriate message when all ships are sunk.