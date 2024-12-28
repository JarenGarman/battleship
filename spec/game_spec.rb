require 'spec_helper'

RSpec.describe Game do
  let(:game) { described_class.new }
  #let will create a local variable named game that is initialized with a new instance of the Game class. 
  #(:game) is the name of the variable that will be created.
  #{described_class.new} is the value that the variable will be initialized with.

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

  describe '#handle_main_menu_input' do #tests that the handle_main_menu_input method correctly handles input
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
end

