require_relative 'board'
require_relative 'ship'

DEBUG_MODE = false

class Computer
  def place_ships(board)
    @computer_ships = [
      Ship.new('Cruiser', 3),
      Ship.new('Submarine', 2)
    ]
    @computer_ships.each do |ship|
      loop do
        orientation = ['horizontal', 'vertical'].sample
        row = rand(4)
        col = rand(4)

        if orientation == 'horizontal'
          coordinates = (col..(col + ship.length - 1)).map { |c| ("A".ord + row).chr + (c + 1).to_s }
        else
          coordinates = (row..(row + ship.length - 1)).map { |r| ("A".ord + r).chr + (col + 1).to_s }
        end

        if board.valid_placement?(ship, coordinates)
          board.place(ship, coordinates)
          puts "DEBUG: Computer ship #{ship.name} placed at #{coordinates.inspect}" if DEBUG_MODE
          break
        end
      end
    end
  end
end
