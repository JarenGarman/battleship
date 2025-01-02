require_relative 'computer'
require_relative 'user'
require_relative 'board'
require_relative 'ship'

# Play the game!
class Game
  attr_reader :player_board, :computer_board

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @player_shots = []
    @computer_shots = []
  end

  def start
    puts 'Welcome to BATTLESHIP'
    puts "Enter 'p' to play. Enter 'q' to quit."
    handle_main_menu_input
  end

  private

  def handle_main_menu_input
    case gets.chomp.downcase
    when 'p'
      start_game
    when 'q'
      puts 'Quitting game...'
      exit
    else
      puts "Invalid input. Please enter 'p' to play or 'q' to quit."
      handle_main_menu_input
    end
  end

  def start_game
    setup_game
    play_game
  end

  def setup_game
    # Setup ships on both boards
    cruiser = Ship.new('Cruiser', 3)
    submarine = Ship.new('Submarine', 2)
    @player_board.place(cruiser, ['A1', 'A2', 'A3'])
    @player_board.place(submarine, ['B1', 'B2'])
    puts "DEBUG: Player board ships: #{@player_board.ships.map(&:name).inspect}"
  end

  def play_game
    loop do
      render_boards
      player_turn
      render_boards
      break if game_over?

      computer_turn
      render_boards
      break if game_over?
    end
    display_winner
  end

  def render_boards
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
  end

  def player_turn
    coordinate = nil
    loop do
      puts 'Enter the coordinate for your shot:'
      coordinate = gets.chomp.upcase
      if !@computer_board.valid_coordinate?(coordinate)
        puts 'Please enter a valid coordinate:'
      elsif @player_shots.include?(coordinate)
        puts 'You have already fired on this coordinate. Please enter a new coordinate:'
      else
        break
      end
    end
    result = @computer_board.fire_upon(coordinate)
    @player_shots << coordinate
    puts "DEBUG: Player shot coordinates: #{@player_shots.inspect}"
    puts "Your shot on #{coordinate} was a #{result}."
  end

  def computer_turn
    coordinate = nil
    loop do
      coordinate = random_coordinate
      break unless @computer_shots.include?(coordinate)
    end
    result = @player_board.fire_upon(coordinate)
    @computer_shots << coordinate
    puts "DEBUG: Computer shot coordinates: #{@computer_shots.inspect}"
    puts "My shot on #{coordinate} was a #{result}."
  end

  def random_coordinate
    rows = ('A'..'D').to_a
    columns = (1..4).to_a
    "#{rows.sample}#{columns.sample}"
  end

  def game_over?
    @player_board.all_ships_sunk? || @computer_board.all_ships_sunk?
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    else
      puts "You won! All enemy ships have been sunk."
    end
  end
end