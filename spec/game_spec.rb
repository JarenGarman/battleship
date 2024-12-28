require 'spec_helper'

RSpec.describe Game do
  let(:game) { described_class.new }

  describe '#initialize' do
    it 'initializes with game_over set to false' do #tests that the Game class initializes with game_over set to false
      expect(game.instance_variable_get(:@game_over)).to eq(false)
    end
  end

  describe '#display_main_menu' do
    before do
      allow(game).to receive(:gets).and_return('q')
    end

    it 'displays the main menu' do #tests that the display_main_menu method displays the main menu
      expect { game.display_main_menu }.to output("Welcome to BATTLESHIP\nEnter 'p' to play. Enter 'q' to quit.\n").to_stdout
    end
  end

  describe '#handle_main_menu_input' do #tests that the handle_main_menu_input method starts the game when input is 'p', quits the game when input is 'q', and redisplays the main menu when input is invalid
    before do
      allow(game).to receive(:gets).and.return(input)
    end

    context "when input is 'p'" do #when input is 'p'
      let(:input) { 'p' }

      it 'starts the game' do #starts the game
        expect(game).to receive(:start_game)
        game.send(:handle_main_menu_input)
      end
    end

    context "when input is 'q'" do #when input is 'q'
      let(:input) { 'q' }

      it 'quits the game' do #quits the game
        expect { game.send(:handle_main_menu_input) }.to output(/Quitting game.../).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when input is invalid" do #when input is invalid
      let(:input) { 'invalid' }

      it 'displays an invalid input message and redisplays the main menu' do #displays an invalid input message and redisplays the main menu
        expect(game).to receive(:display_main_menu).twice
        expect { game.send(:handle_main_menu_input) }.to output(/Invalid input/).to_stdout
      end
    end
  end

  describe '#start_game' do
    it 'calls setup_game, play_game, and end_game' do #tests that the start_game method calls setup_game, play_game, and end_game
      expect(game).to receive(:setup_game)
      expect(game).to receive(:play_game)
      expect(game).to receive(:end_game)
      game.start_game
    end
  end

  describe '#check_game_over' do #tests that the check_game_over method correctly sets the game over state and displays the appropriate message when all ships are sunk
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

  describe '#end_game' do #tests that the end_game method displays game over message and returns to main menu
    it 'displays game over message and returns to main menu' do
      expect(game).to receive(:display_main_menu)
      expect { game.send(:end_game) }.to output(/Game over. Returning to main menu.../).to_stdout
    end
  end
end