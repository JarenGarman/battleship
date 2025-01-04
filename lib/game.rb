require_relative 'computer'
require_relative 'player'
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
    cpu.place_ships(@computer_board)
    puts 'I have laid out my ships on the grid.'
    puts 'You now need to lay out your two ships.'
    puts 'The Cruiser is three units long and the Submarine is two units long.'

    render_empty_player_board

    player = Player.new(@player_board)
    player.place_ships(ships)
    render_boards(player)

    play_game(player)
  end

  def render_boards(player)
    puts '=============COMPUTER BOARD============='
    puts @computer_board.render_hidden
    puts '==============PLAYER BOARD=============='
    puts player.board.render(true)
    puts '----------------------------------------'
  end

  def render_empty_player_board
    puts '==============PLAYER BOARD=============='
    puts @player_board.render(true)
    puts '----------------------------------------'
  end

  def play_game(player)
    loop do
      render_boards(player)

      # Player's turn
      player_shot_result = player_turn
      puts player_shot_result
      puts '----------------------------------------'

      # Check if the player has won
      if @computer_board.all_ships_sunk?
        puts "\nYou won! All enemy ships have been sunk."
        break
      end

      # Computer's turn
      computer_shot_result = computer_turn
      puts computer_shot_result
      puts '----------------------------------------'

      # Check if the computer has won
      if @player_board.all_ships_sunk?
        puts "\nYou lost! All your ships have been sunk."
        break
      end

      puts
    end
  end

  def player_turn
    coordinate = get_valid_coordinate
    result = fire_at_computer(coordinate)
    handle_result("Your", result, coordinate, @computer_board)
    result
  end

  def computer_turn
    coordinate = get_random_coordinate
    result = fire_shot(coordinate, @player_board)
    handle_result("My", result, coordinate, @player_board)
    result
  end

  def fire_at_computer(coordinate)
    if @computer_board.valid_coordinate?(coordinate)
      @computer_board.fire_upon(coordinate)
      if @computer_board.cell_ship(coordinate)
        return "hit"
      else
        return "miss"
      end
    else
      return "invalid"
    end
  end

  def fire_shot(coordinate, board)
    cell = board.cell_at(coordinate)
    if cell == 'M' || cell == 'X'
      return "already_fired"
    end
    board.fire_upon(coordinate)
    if cell == 'S'
      return "hit"
    else
      return "miss"
    end
  end

  def handle_result(player, result, coordinate, board)
    case result
    when "hit"
      puts "#{player} shot on #{coordinate} was a hit!"
      ship = board.cell_ship(coordinate)
      if ship && ship.sunk?
        puts "#{ship.name} has been sunk!"
        ship.positions.each do |pos|
          board.cell_at(pos).fire_upon
        end
      end
    when "miss"
      puts "#{player} shot on #{coordinate} was a miss."
    when "already_fired"
      puts "#{player} shot on #{coordinate} has already been fired upon."
    end
  end

  def get_valid_coordinate
    loop do
      puts 'Enter the coordinate for your shot (e.g., B2):'
      coordinate = gets.chomp.upcase
      if !@computer_board.valid_coordinate?(coordinate)
        puts 'Please enter a valid coordinate (e.g., B2):'
        next
      elsif @player_shots.include?(coordinate)
        puts 'You have already fired on this coordinate. Please enter a new coordinate:'
        next
      else
        @player_shots << coordinate
        return coordinate
      end
    end
  end

  def get_random_coordinate
    loop do
      row = ('A'..'D').to_a.sample
      col = rand(1..4).to_s
      coordinate = row + col
      return coordinate unless @computer_shots.include?(coordinate)
    end
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    elsif @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
    end
    exit_game
  end

  def exit_game
    puts "Exiting game..."
    exit
  end
end