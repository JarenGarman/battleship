require_relative 'board'
require_relative 'ship'

# The enemy of the player
class Computer
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
      @board.place(ship, rand_coordinates(ship))
    end
  end

  def guess_shot(board)
    if board.cells.values.any? { |cell| cell.fired_upon? && cell.ship && !cell.ship.sunk? }
      hunt_target(board)
    else
      board.cells.values.reject(&:fired_upon?).sample.coordinate
    end
  end

  private

  def hunt_target(board) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    board.cells.values.select { |cell| cell.fired_upon? && cell.ship && !cell.ship.sunk? }.map do |cell|
      row = cell.coordinate[0]
      column = cell.coordinate[1..]
      above = (row.ord - 1).chr + column
      below = (row.ord + 1).chr + column
      left = row + (column.to_i - 1).to_s
      right = row + (column.to_i + 1).to_s
      [above, below, left, right].select do |coordinate|
        board.valid_coordinate?(coordinate) && !board.cells[coordinate].fired_upon?
      end
    end.flatten.uniq.sample
  end

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
