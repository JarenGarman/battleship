require_relative 'board'
require_relative 'ship'

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
          @board.place(ship, coordinates)
          placed = true
        end
      end
    end
  end

  private

  def random_coordinate
    rows = ('A'..'D').to_a
    cols = (1..4).to_a
    "#{rows.sample}#{cols.sample}"
  end

  def generate_coordinates(start, length, direction)
    row, col = start.chars
    row_index = ('A'..'D').to_a.index(row)
    col_index = col.to_i - 1

    if direction == :horizontal
      (0...length).map { |i| "#{('A'..'D').to_a[row_index]}#{col_index + i + 1}" }
    else
      (0...length).map { |i| "#{('A'..'D').to_a[row_index + i]}#{col_index + 1}" }
    end
  end
end
