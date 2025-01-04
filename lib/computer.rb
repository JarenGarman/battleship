require_relative 'board'
require_relative 'ship'

DEBUG_MODE = false

class Computer
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def place_ships(ships)
    ships.each do |ship|
      placed = false
      until placed
        start_coordinate = random_coordinate
        direction = [:horizontal, :vertical].sample
        coordinates = generate_coordinates(start_coordinate, ship.length, direction)
        if @board.valid_placement?(ship, coordinates)
          place_ship(ship, coordinates, direction)
          placed = true
          puts "DEBUG: Computer ship #{ship.name} placed at #{coordinates.inspect}" if DEBUG_MODE
          puts "DEBUG: Computer ships after placing #{ship.name}: #{@board.ships.map(&:positions).inspect}" if DEBUG_MODE
        end
      end
    end
  end

  def place_computer_ships
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)
    ships = [cruiser, submarine]
    place_ships(ships)
  end

  private

  def random_coordinate
    rows = ('A'..'D').to_a
    cols = (1..4).to_a
    "#{rows.sample}#{cols.sample}"
  end

  def generate_coordinates(start_coordinate, length, direction)
    row = start_coordinate[0]
    col = start_coordinate[1..-1].to_i

    coordinates = []
    if direction == :horizontal
      (0...length).each do |i|
        coordinates << "#{row}#{col + i}"
      end
    else
      (0...length).each do |i|
        coordinates << "#{(row.ord + i).chr}#{col}"
      end
    end
    coordinates
  end

  def place_ship(ship, coordinates, direction)
    coordinates.each do |coordinate|
      @board.cells[coordinate].place_ship(ship)
    end
    ship.positions = coordinates
    @board.ships << ship
  end
end
