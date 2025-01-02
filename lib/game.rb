require_relative 'user'
require_relative 'board'
require_relative 'ship'
require_relative 'computer'

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
    cruiser = Ship.new('Cruiser', 3)
    submarine = Ship.new('Submarine', 2)
    ships = [cruiser, submarine]

    # Place ships for the computer
    cpu = Computer.new
    cpu.place_ships(ships)
    @computer_board = cpu.board  # Assign computer's board here.
    puts "DEBUG: Computer board ships: #{@computer_board.ships.map(&:name)}"  # Debugging output

    # Place ships for the user
    user = User.new
    user.place_ships(ships)
    @player_board = user.board  # Assign player's board here.
    puts "DEBUG: Player board ships: #{@player_board.ships.map(&:name)}"  # Debugging output

    render_boards(user)

    # Start the game with the user
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
      render_boards(user)
      break if game_over?

      computer_turn
      render_boards(user)
      break if game_over?
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
    player_lost = @player_board.all_ships_sunk?
    computer_lost = @computer_board.all_ships_sunk?

    puts "DEBUG: Player lost? #{player_lost}"
    puts "DEBUG: Computer lost? #{computer_lost}"

    player_lost || computer_lost
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "DEBUG: Player lost. All ships have been sunk."
      puts "You lost! All your ships have been sunk."
    elsif @computer_board.all_ships_sunk?
      puts "DEBUG: Computer lost. All enemy ships have been sunk."
      puts "You won! All enemy ships have been sunk."
    end
  end
end