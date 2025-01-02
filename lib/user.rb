require_relative 'board'
require_relative 'ship'

class User
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def place_ships(ships)
    ships.each do |ship|
      coordinates = get_valid_coordinates(ship)
      @board.place(ship, coordinates)
      render_board
    end
  end

  def get_valid_coordinates(ship)
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
    coordinates = gets.chomp.split
    until @board.valid_placement?(ship, coordinates)
      puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.split
    end
    coordinates
  end

  def render_board
    puts @board.render(true)
  end
end