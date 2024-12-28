require 'rspec'
require './lib/game'

RSpec.describe Game do
  describe '#initialize' do
    it 'initializes with game_over set to false' do
      game = Game.new
      expect(game.instance_variable_get(:@game_over)).to eq(false)
    end
  end

  describe '#display_main_menu' do
    it 'displays the main menu' do
      game = Game.new
      expect { game.display_main_menu }.to output(/Welcome to BATTLESHIP/).to_stdout
    end
  end

  describe '#handle_main_menu_input' do
    before do
      allow_any_instance_of(Game).to receive(:gets).and_return(input)
    end

    context "when input is 'p'" do
      let(:input) { 'p' }

      it 'starts the game' do
        game = Game.new
        expect(game).to receive(:start_game)
        game.send(:handle_main_menu_input)
      end
    end

    context "when input is 'q'" do
      let(:input) { 'q' }

      it 'quits the game' do
        game = Game.new
        expect { game.send(:handle_main_menu_input) }.to output(/Quitting game.../).to_stdout.and raise_error(SystemExit)
      end
    end

    context "when input is invalid" do
      let(:input) { 'invalid' }

      it 'displays an invalid input message and redisplays the main menu' do
        game = Game.new
        expect(game).to receive(:display_main_menu).twice
        expect { game.send(:handle_main_menu_input) }.to output(/Invalid input/).to_stdout
      end
    end
  end

  describe '#start_game' do
    it 'starts the game and ends the game' do
      game = Game.new
      expect(game).to receive(:end_game)
      expect { game.start_game }.to output(/Starting game.../).to_stdout
    end
  end

  describe '#end_game' do
    it 'displays game over message and returns to main menu' do
      game = Game.new
      expect(game).to receive(:display_main_menu)
      expect { game.send(:end_game) }.to output(/Game over. Returning to main menu.../).to_stdout
    end
  end
end