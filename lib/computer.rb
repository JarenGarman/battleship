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
    coords = []
    until @board.valid_placement?(ship, coords)
      horizontal_bool = Random.new.rand(2).zero?
      start_coord = generate_start_coord(ship.length, horizontal_bool)
      coords = generate_remaining_coords(ship.length, horizontal_bool, start_coord)
    end
    coords
  end

  def generate_start_coord(length, horizontal)
    @board.cells.values.select do |cell|
      if horizontal
        cell.coordinate[1].to_i < 6 - length
      else
        cell.coordinate[0].ord < 70 - length
      end && cell.empty?
    end.sample.coordinate
  end

  def generate_remaining_coords(length, horizontal, start_coord)
    coords = []
    length.times do |i|
      coords << if horizontal
                  "#{start_coord[0]}#{start_coord[1].to_i + i}"
                else
                  "#{(start_coord[0].ord + i).chr}#{start_coord[1]}"
                end
    end
    coords
  end
end
