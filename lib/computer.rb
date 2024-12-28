require_relative 'board'
require_relative 'ship'

# The enemy of the player
class Computer
  attr_reader :board

  def initialize
    @board = Board.new
    @cruiser = Ship.new('Cruiser', 3)
    @submarine = Ship.new('Submarine', 2)
    place([@cruiser, @submarine])
  end

  private

  def place(ships)
    ships.each do |ship|
      @board.place(ship, rand_coordinates(ship))
    end
  end

  def rand_coordinates(ship)
    @prng = Random.new
    coords = []
    until @board.valid_placement?(ship, coords)
      coords = if @prng.rand(2).zero?
                 horizontal_coords(ship)
               else
                 vertical_coords(ship)
               end
    end
    coords
  end

  def horizontal_coords(ship)
    case ship.length
    when 3
      filtered_board = @board.cells.reject { |coord, cell| coord[1].to_i > 2 || !cell.empty? }
      start_coord = filtered_board.keys.sample
      [start_coord, "#{start_coord[0]}#{start_coord[1].to_i + 1}", "#{start_coord[0]}#{start_coord[1].to_i + 2}"]
    when 2
      filtered_board = @board.cells.reject { |coord, cell| coord[1].to_i > 3 || !cell.empty? }
      start_coord = filtered_board.keys.sample
      [start_coord, "#{start_coord[0]}#{start_coord[1].to_i + 1}"]
    end
  end

  def vertical_coords(ship)
    case ship.length
    when 3
      filtered_board = @board.cells.reject { |coord, cell| coord[0].ord > 66 || !cell.empty? }
      start_coord = filtered_board.keys.sample
      [start_coord, "#{(start_coord[0].ord + 1).chr}#{start_coord[1]}", "#{(start_coord[0].ord + 2).chr}#{start_coord[1]}"]
    when 2
      filtered_board = @board.cells.reject { |coord, cell| coord[0].ord > 67 || !cell.empty? }
      start_coord = filtered_board.keys.sample
      [start_coord, "#{(start_coord[0].ord + 1).chr}#{start_coord[1]}"]
    end
  end
end
