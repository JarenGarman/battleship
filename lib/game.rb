require_relative 'computer'
require_relative 'player'
require_relative 'board'
require_relative 'ship'

# Play the game!
class Game # rubocop:disable Metrics/ClassLength
  def start
    puts
    puts 'Welcome to BATTLESHIP'
    puts
    puts "Enter 'p' to play. Enter 'q' to quit."
    handle_main_menu_input
  end

  private

  def ships
    {
      carrier: ['Carrier', 5],
      battleship: ['Battleship', 4],
      cruiser: ['Cruiser', 3],
      submarine: ['Submarine', 3],
      destroyer: ['Destroyer', 2]
    }.freeze
  end

  def handle_main_menu_input
    case gets.chomp.downcase
    when 'p'
      select_size
    when 'q'
      exit_game
    else
      puts
      puts "Invalid input. Please enter 'p' to play or 'q' to quit."
      handle_main_menu_input
    end
  end

  def select_size # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    puts
    puts "Please select your game size. Enter 'm' for mini or 'c' for classic, 'q' to quit, or 'x' for main menu."
    case gets.chomp.downcase
    when 'm'
      start_game({ length: 4, width: 4 }, [ships[:cruiser], ships[:destroyer]])
    when 'c'
      start_game({ length: 10, width: 10 }, ships.values)
    when 'q'
      exit_game
    when 'x'
      start
    else
      puts
      puts 'Invalid input.'
      select_size
    end
  end

  def start_game(dimensions, game_ships) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    puts
    puts 'Starting game...'
    puts
    @computer = Computer.new(Board.new(dimensions))
    @computer.add_ships(game_ships.map { |ship| Ship.new(ship[0], ship[1]) })
    @computer.place_ships
    puts "I have laid out my ships on the grid.\nYou now need to lay out your ships:\n\n"
    game_ships.each do |ship|
      puts "#{ship[0]}: #{ship[1]} spaces"
    end
    puts
    @player = Player.new(Board.new(dimensions))
    @player.add_ships(game_ships.map { |ship| Ship.new(ship[0], ship[1]) })
    @player.place_ships
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

  def play_game # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity,Metrics/AbcSize
    until @computer.ships.all?(&:sunk?) || @player.ships.all?(&:sunk?)
      render_boards
      player_turn
      break if @computer.ships.all?(&:sunk?)

      puts
      puts '----------------------------------------'
      computer_turn
      break if @player.ships.all?(&:sunk?)

      puts
      puts '----------------------------------------'
      puts
    end
    display_winner
  end

  def player_turn
    coordinate = get_valid_coordinate
    return if coordinate.nil?

    result = fire_shot(coordinate, @computer.board)
    puts
    puts '----------------------------------------'
    handle_result('Your', 'My', result, coordinate, @computer.board)
  end

  def computer_turn
    coordinate = @computer.guess_shot(@player.board)
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

  def get_valid_coordinate # rubocop:disable Metrics/MethodLength,Naming/AccessorMethodName,Metrics/AbcSize
    loop do
      puts "Enter the coordinate for your shot (e.g., B2), 'q' to quit, or 'x' for main menu:"
      input = gets.chomp.upcase
      case input
      when 'Q'
        exit_game
      when 'X'
        start
        return nil
      else
        if !@computer.board.valid_coordinate?(input)
          puts
          puts 'Please enter a valid coordinate.'
          next
        elsif @computer.board.cells[input].fired_upon?
          puts
          puts "You have already fired on #{input}. Please enter a new coordinate."
          next
        else
          return input
        end
      end
    end
  end

  def display_winner
    puts
    render_boards
    if @player.ships.all?(&:sunk?)
      puts 'You lost! All your ships have been sunk.'
    else
      puts 'You won! All enemy ships have been sunk.'
    end
    puts
    puts '----------------------------------------'
    start
  end

  def exit_game
    puts
    puts 'Exiting game...'
    exit
  end
end
