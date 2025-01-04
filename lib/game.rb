require_relative 'computer'
require_relative 'player'
require_relative 'board'
require_relative 'ship'

# Play the game!
class Game # rubocop:disable Metrics/ClassLength
  def start
    puts
    puts
    puts
    puts 'Welcome to BATTLESHIP'
    puts
    puts "Enter 'p' to play. Enter 'q' to quit."
    puts
    handle_main_menu_input
  end

  private

  def handle_main_menu_input
    case gets.chomp.downcase
    when 'p'
      start_game
    when 'q'
      exit_game
    else
      puts "Invalid input. Please enter 'p' to play or 'q' to quit."
    end
  end

  def start_game # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    puts
    puts 'Starting game...'
    puts
    ships = [['Cruiser', 3], ['Submarine', 2]]
    @computer = Computer.new
    @computer_ships = ships.map { |ship| Ship.new(ship[0], ship[1]) }
    @computer.place_ships(@computer_ships)
    puts "I have laid out my ships on the grid.\nYou now need to lay out your two ships.\nThe Cruiser is three units long and the Submarine is two units long.\n" # rubocop:disable Layout/LineLength
    puts
    @player = Player.new
    @player_ships = ships.map { |ship| Ship.new(ship[0], ship[1]) }
    @player.place_ships(@player_ships)
    puts
    play_game
  end

  def render_boards
    puts '=============COMPUTER BOARD============='
    puts
    puts @computer.board.render
    puts
    puts '==============PLAYER BOARD=============='
    puts
    puts @player.board.render(true)
    puts
    puts '----------------------------------------'
    puts
  end

  def play_game # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    until @computer_ships.all?(&:sunk?) || @player_ships.all?(&:sunk?)
      render_boards
      player_turn
      break if @computer_ships.all?(&:sunk?)

      puts
      puts '----------------------------------------'
      puts
      computer_turn
      break if @player_ships.all?(&:sunk?)

      puts
      puts '----------------------------------------'
      puts
    end
    display_winner
  end

  def player_turn
    coordinate = get_valid_coordinate
    result = fire_shot(coordinate, @computer.board)
    handle_result('Your', 'My', result, coordinate, @computer.board)
  end

  def computer_turn
    coordinate = get_random_coordinate
    result = fire_shot(coordinate, @player.board)
    handle_result('My', 'Your', result, coordinate, @player.board)
  end

  def fire_shot(coordinate, board)
    board.cells[coordinate].fire_upon
    return 'hit' if board.cells[coordinate].ship

    'miss'
  end

  def handle_result(player, opponent, result, coordinate, board)
    puts
    case result
    when 'hit'
      puts "#{player} shot on #{coordinate} was a hit!"
      ship = board.cells[coordinate].ship
      puts "\n#{opponent} #{ship.name} has been sunk!" if ship.sunk?
    when 'miss'
      puts "#{player} shot on #{coordinate} was a miss."
    end
  end

  def get_valid_coordinate # rubocop:disable Metrics/MethodLength,Naming/AccessorMethodName
    loop do
      puts 'Enter the coordinate for your shot (e.g., B2):'
      puts
      coordinate = gets.chomp.upcase
      if !@computer.board.valid_coordinate?(coordinate)
        puts 'Please enter a valid coordinate (e.g., B2):'
        next
      elsif @computer.board.cells[coordinate].fired_upon?
        puts "You have already fired on #{coordinate}. Please enter a new coordinate:"
        next
      else
        return coordinate
      end
    end
  end

  def get_random_coordinate # rubocop:disable Naming/AccessorMethodName
    @player.board.cells.values.reject(&:fired_upon?).sample.coordinate
  end

  def display_winner
    puts
    if @player_ships.all?(&:sunk?)
      puts 'You lost! All your ships have been sunk.'
    else
      puts 'You won! All enemy ships have been sunk.'
    end
    puts
    start
  end

  def exit_game
    puts
    puts 'Exiting game...'
    exit
  end
end
