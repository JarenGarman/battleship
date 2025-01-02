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
    puts 'Starting game...'
    cruiser = Ship.new('Cruiser', 3)
    submarine = Ship.new('Submarine', 2)
    ships = [cruiser, submarine]

    cpu = Computer.new
    cpu.place_ships(ships)
    puts 'I have laid out my ships on the grid.'
    puts 'You now need to lay out your two ships.'
    puts 'The Cruiser is three units long and the Submarine is two units long.'

    user = User.new
    user.place_ships(ships)
    render_boards(user)

    play_game(user)
  end

  def render_boards(user)
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render
    puts '==============PLAYER BOARD=============='
    puts user.board.render(true)
  end

  def play_game(user)
    loop do
      render_boards(user)
      player_turn
      break if game_over?

      computer_turn
      break if game_over?

      render_boards(user)
    end
    display_winner
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
    puts "Your shot on #{coordinate} was a #{result}."
  end

  def computer_turn
    coordinate = get_random_coordinate
    result = @player_board.fire_upon(coordinate)
    @computer_shots << coordinate
    puts "My shot on #{coordinate} was a #{result}."
  end

  def get_random_coordinate
    loop do
      coordinate = random_coordinate
      return coordinate unless @computer_shots.include?(coordinate)
    end
  end

  def random_coordinate
    rows = ('A'..'D').to_a
    columns = (1..4).to_a
    "#{rows.sample}#{columns.sample}"
  end

  def game_over?
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
      true
    elsif @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
      true
    else
      false
    end
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    else
      puts "You won! All enemy ships have been sunk."
    end
  end
end