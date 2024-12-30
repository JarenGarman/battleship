require_relative 'board'
require_relative 'ship'

# The enemy of the player
class Computer
  attr_reader :board

  def initialize(board = Board.new)
    @board = board
  end

  def place_ships(ships)
    ships.each do |ship|
      @board.place(ship, rand_coordinates(ship))
    end
  end

  private

  def rand_coordinates(ship)
    coords = []
    h_or_v = [0, 1]
    until @board.valid_placement?(ship, coords)
      horizontal, vertical = h_or_v.shuffle
      start_coord = generate_start_coord(ship.length, horizontal, vertical)
      coords = generate_remaining_coords(ship.length, horizontal, vertical, start_coord)
    end
    coords
  end

  def generate_start_coord(ship_length, horizontal, vertical) # rubocop:disable Metrics/AbcSize
    @board.cells.values.select do |cell|
      cell.coordinate[0].ord < (66 + @board.rows.length) - (ship_length * horizontal) &&
        cell.coordinate[1].to_i < (2 + @board.columns.length) - (ship_length * vertical) &&
        cell.empty?
    end.sample.coordinate
  end

  def generate_remaining_coords(ship_length, horizontal, vertical, start_coord)
    coords = []
    ship_length.times do |i|
      coords << "#{(start_coord[0].ord + (i * vertical)).chr}#{start_coord[1].to_i + (i * horizontal)}"
    end
    coords
  end
end
