require_relative 'ship'
require_relative 'board'

# Enemy of the computer
class User
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def place_ships(ships)
    ships.each do |ship|
      @board.place(ship, get_valid_coordinates(ship))
      @board.render(true)
    end
  end

  private

  def get_valid_coordinates(ship)
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
    coordinates = gets.chomp.upcase.split
    until @board.valid_placement?(ship, coordinates)
      puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.upcase.split
    end
    coordinates
  end
end
