require_relative 'ship'
require_relative 'board'

# Enemy of the computer
class Player
  attr_reader :board, :ships

  def initialize(board = Board.new)
    @board = board
    @ships = []
  end

  def add_ships(ships)
    ships.map { |ship| @ships << ship }
  end

  def place_ships
    @ships.each do |ship|
      puts @board.render(true)
      puts
      coordinates = get_valid_coordinates(ship)
      return if coordinates.nil?

      @board.place(ship, coordinates)
    end
  end

  private

  def get_valid_coordinates(ship) # rubocop:disable Metrics/AbcSize
    loop do
      puts "Enter the squares for the #{ship.name} (#{ship.length} spaces) separated by spaces (e.g., A1 A2 A3), 'q' to quit, or 'x' for main menu:"
      input = gets.chomp.upcase
      case input
      when 'Q'
        exit_game
      when 'X'
        start
        return nil
      else
        coordinates = input.split
        if @board.valid_placement?(ship, coordinates)
          return coordinates
        else
          puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces), 'q' to quit, or 'x' for main menu:"
        end
      end
    end
  end

  def exit_game
    puts
    puts 'Exiting game...'
    exit
  end

  def start
    Game.new.start
  end
end
