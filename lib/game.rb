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

    # Place ships for the user
    user = User.new
    user.place_ships(ships)
    @player_board = user.board  # Assign player's board here.

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

      # Player's turn
      puts "Your turn:"
      player_shot_result = player_turn
      puts player_shot_result

      # Check if the player has won
      if @computer_board.all_ships_sunk?
        puts "You won! All enemy ships have been sunk."
        break
      end

      # Computer's turn
      puts "My turn:"
      computer_shot_result = computer_turn
      puts computer_shot_result

      # Check if the computer has won
      if @player_board.all_ships_sunk?
        puts "You lost! All your ships have been sunk."
        break
      end
    end
    display_winner
  end

  def player_turn
    coordinate = nil
    loop do
      puts 'Enter the coordinate for your shot:'
      coordinate = gets.chomp.upcase
      if !@computer_board.valid_coordinate?(coordinate)
        puts 'Invalid coordinate. Please enter a valid one.'
      elsif @player_shots.include?(coordinate)
        puts 'You have already fired on this coordinate. Try another one.'
      else
        break
      end
    end
    result = @computer_board.fire_upon(coordinate)
    @player_shots << coordinate

    case result
    when :miss
      "Your shot on #{coordinate} was a miss."
    when :hit
      "Your shot on #{coordinate} was a hit!"
    when :sunk
      "You sunk my ship at #{coordinate}!"
    else
      "Unexpected result: #{result}"
    end
  end

  def computer_turn
    coordinate = nil
    loop do
      coordinate = random_coordinate
      break unless @computer_shots.include?(coordinate)
    end
    result = @player_board.fire_upon(coordinate)
    @computer_shots << coordinate

    case result
    when :miss
      "My shot on #{coordinate} was a miss."
    when :hit
      "My shot on #{coordinate} was a hit!"
    when :sunk
      "I sunk your ship at #{coordinate}!"
    else
      "Unexpected result: #{result}"
    end
  end

  def random_coordinate
    rows = ('A'..'D').to_a
    columns = (1..4).to_a
    "#{rows.sample}#{columns.sample}"
  end

  def game_over?
    player_lost = @player_board.all_ships_sunk?
    computer_lost = @computer_board.all_ships_sunk?

    player_lost || computer_lost
  end

  def display_winner
    if @player_board.all_ships_sunk?
      puts "You lost! All your ships have been sunk."
    elsif @computer_board.all_ships_sunk?
      puts "You won! All enemy ships have been sunk."
    end
  end
end