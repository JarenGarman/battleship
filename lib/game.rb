require_relative 'computer'
require_relative 'user'
require_relative 'board'
require_relative 'ship'

DEBUG_MODE = false

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

    render_empty_player_board

    user = User.new(@player_board)
    user.place_ships(ships)
    render_boards

    play_game
  end

  def render_empty_player_board
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
    puts '----------------------------------------'
  end

  def render_boards
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
    puts '----------------------------------------'
  end

  def play_game
    loop do
      display_game_state

      # Player's turn
      player_turn
      break if check_win_condition

      puts '----------------------------------------'

      # Computer's turn
      computer_turn
      break if check_win_condition

      puts '----------------------------------------'
    end
    exit_game
  end

  def player_turn
    coordinate = get_valid_coordinate
    result = fire_shot(coordinate, @computer_board)
    handle_result("Your", result, coordinate, @computer_board)
    display_game_state
  end

  def computer_turn
    coordinate = get_random_coordinate
    result = fire_shot(coordinate, @player_board)
    handle_result("My", result, coordinate, @player_board)
    display_game_state
  end

  def fire_shot(coordinate, board)
    cell = board.cell_at(coordinate)
    if cell.fired_upon?
      return "already_fired"
    end
    cell.fire_upon
    return cell.ship.nil? ? "miss" : "hit"
  end

  def handle_result(player, result, coordinate, board)
    case result
    when "hit"
      ship = board.cell_ship(coordinate)
      puts "DEBUG: #{player} shot on #{coordinate} hit #{ship.name}. Health: #{ship.health}" if DEBUG_MODE
      if ship.sunk?
        puts "DEBUG: #{ship.name} has been sunk!" if DEBUG_MODE
        check_victory if player == "Your"
      end
      puts "#{player} shot on #{coordinate} was a hit!"
    when "miss"
      puts "DEBUG: #{player} shot on #{coordinate} missed." if DEBUG_MODE
      puts "#{player} shot on #{coordinate} was a miss."
    when "already_fired"
      puts "DEBUG: #{player} shot on #{coordinate} was already fired upon." if DEBUG_MODE
      puts "#{player} shot on #{coordinate} has already been fired upon."
    end
  end

  def get_valid_coordinate
    loop do
      puts 'Enter the coordinate for your shot:'
      coordinate = gets.chomp.upcase
      if !@computer_board.valid_coordinate?(coordinate)
        puts 'Please enter a valid coordinate:'
      elsif @player_shots.include?(coordinate)
        puts 'You have already fired on this coordinate. Please enter a new coordinate:'
      else
        @player_shots << coordinate
        return coordinate
      end
    end
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
    @player_board.all_ships_sunk? || @computer_board.all_ships_sunk?
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    elsif @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
    end
    exit_game
  end

  def check_victory
    puts "DEBUG: Checking if all computer ships are sunk: #{@computer_board.all_ships_sunk?}" if DEBUG_MODE
    puts "DEBUG: Computer ships remaining: #{@computer_board.ships.reject(&:sunk?).map(&:name).inspect}" if DEBUG_MODE
    if @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
      exit_game
    elsif @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
      exit_game
    end
  end

  def check_win_condition
    if @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
      return true
    elsif @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
      return true
    end
    false
  end

  def exit_game
    puts "Exiting game..."
    exit
  end

  def display_game_state
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
    puts '----------------------------------------'
  end
end