require 'spec_helper'


RSpec.describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    it { is_expected.to be_instance_of described_class }
  end

  describe '#start' do
    it 'starts the game' do
      expect(game).to respond_to(:start)
    end
  end

  describe '#handle_main_menu_input' do
    before do
      allow(game).to receive(:gets).and_return(input)
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
    it 'calls setup_game and end_game' do
      expect(game).to receive(:setup_game)
      expect(game).to receive(:end_game)
      game.send(:start_game)
    end
  end

  describe '#setup_game' do
    it 'sets up ships for player and computer' do
      player = instance_double(User)
      computer = instance_double(Computer)
      allow(User).to receive(:new).and_return(player)
      allow(Computer).to receive(:new).and_return(computer)
      expect(player).to receive(:place_ships)
      expect(computer).to receive(:place_ships)
      game.send(:setup_game)
    end
  end

  describe '#end_game' do
    it 'displays game over message and returns to main menu' do
      expect(game).to receive(:start)
      expect { game.send(:end_game) }.to output(/Game over. Returning to main menu.../).to_stdout
    end
  end
end

