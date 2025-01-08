require_relative 'board'
require_relative 'ship'

# The enemy of the player
class Computer
  attr_reader :board, :ships, :targets

  def initialize(board = Board.new)
    @board = board
    @ships = []
    @targets = []
  end

  def add_ships(ships)
    ships.map { |ship| @ships << ship }
  end

  def place_ships
    @ships.each do |ship|
      @board.place(ship, rand_coordinates(ship))
    end
  end

  def hunt_target
    if @targets.empty?
      guess_row, guess_col = guess_random
    else
      guess_row, guess_col = @targets.pop
    end

    cell = @board.cells["#{(65 + guess_row).chr}#{guess_col + 1}"]
    if cell.fired_upon? && !cell.empty?
      potential_targets = [
        [guess_row + 1, guess_col],
        [guess_row, guess_col + 1],
        [guess_row - 1, guess_col],
        [guess_row, guess_col - 1]
      ]

      potential_targets.each do |target_row, target_col|
        if target_row.between?(0, @board.rows.length - 1) &&
           target_col.between?(0, @board.columns.length - 1) &&
           !@board.cells["#{(65 + target_row).chr}#{target_col + 1}"].fired_upon? &&
           !@targets.include?([target_row, target_col])
          @targets << [target_row, target_col]
        end
      end
    end

    [guess_row, guess_col]
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

  def guess_random
    row = rand(@board.rows.length)
    col = rand(@board.columns.length)
    [row, col]
  end
end
