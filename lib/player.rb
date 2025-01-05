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
      @board.place(ship, get_valid_coordinates(ship))
    end
  end

  private

  def get_valid_coordinates(ship) # rubocop:disable Metrics/AbcSize
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces) separated by spaces (e.g., A1 A2 A3):"
    coordinates = gets.chomp.upcase.split
    puts
    until @board.valid_placement?(ship, coordinates)
      puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.upcase.split
      puts
    end
    coordinates
  end
end
