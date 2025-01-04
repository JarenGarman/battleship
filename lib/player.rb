require_relative 'ship'
require_relative 'board'

class Player
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def place_ships(ships)
    ships.each do |ship|
      placed = false
      until placed
        puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
        coordinates = gets.chomp.split
        if @board.valid_placement?(ship, coordinates)
          @board.place(ship, coordinates)
          placed = true
          puts "DEBUG: #{ship.name} placed at #{coordinates.inspect}" if DEBUG_MODE
        else
          puts "Those are invalid coordinates. Please try again."
        end
      end
    end
  end
end