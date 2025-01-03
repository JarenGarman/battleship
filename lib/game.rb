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

    # Explanation for the user
    puts "I have laid out my ships on the grid."
    puts "You now need to lay out your two ships."
    puts "The Cruiser is three units long and the Submarine is two units long."

    # Display the empty player board grid
    user = User.new
    @player_board = user.board  # Assign player's board here.
    render_grid(@player_board)

    # Place ships for the user
    user.place_ships(ships)

    play_game
  end

  def render_boards
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
    puts '----------------------------------------'
  end

  def render_grid(board)
    puts board.render(true)
    puts '----------------------------------------'
  end

  def play_game
    loop do
      render_boards
      player_turn
      break if game_over?

      computer_turn
      break if game_over?
    end
    announce_winner
  end

  def player_turn
    coordinate = get_valid_coordinate
    result = @computer_board.fire_upon(coordinate)
    handle_result("Your", result, coordinate, @computer_board)
  end

  def computer_turn
    coordinate = get_random_coordinate
    result = @player_board.fire_upon(coordinate)
    handle_result("My", result, coordinate, @player_board)
  end

  def handle_result(player, result, coordinate, board)
    case result
    when "hit"
      ship = board.cell_ship(coordinate)
      if ship.sunk?
        puts "#{player} shot on #{coordinate} sunk the #{ship.name}!"
      else
        puts "#{player} shot on #{coordinate} was a hit!"
      end
    when "miss"
      puts "#{player} shot on #{coordinate} was a miss."
    when "already_fired"
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
      unless @computer_shots.include?(coordinate)
        @computer_shots << coordinate
        return coordinate
      end
    end
  end

  def random_coordinate
    rows = ('A'..'D').to_a
    columns = (1..4).to_a
    "#{rows.sample}#{columns.sample}"
  end

  def game_over?
    if @player_board.all_ships_sunk?
      puts "DEBUG: Player lost. All ships have been sunk."
      true
    elsif @computer_board.all_ships_sunk?
      puts "DEBUG: Computer lost. All ships have been sunk."
      true
    else
      false
    end
  end

  def announce_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    elsif @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
    end
  end
end