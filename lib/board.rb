require_relative 'cell'

# Create a board that contains Cells for the game
class Board
  attr_reader :cells

  def initialize
    @cells = {
      'A1' => Cell.new('A1'), 'A2' => Cell.new('A2'), 'A3' => Cell.new('A3'), 'A4' => Cell.new('A4'),
      'B1' => Cell.new('B1'), 'B2' => Cell.new('B2'), 'B3' => Cell.new('B3'), 'B4' => Cell.new('B4'),
      'C1' => Cell.new('C1'), 'C2' => Cell.new('C2'), 'C3' => Cell.new('C3'), 'C4' => Cell.new('C4'),
      'D1' => Cell.new('D1'), 'D2' => Cell.new('D2'), 'D3' => Cell.new('D3'), 'D4' => Cell.new('D4')
    }
  end

  def valid_coordinate?(coordinate)
    @cells.key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    return false unless coordinates.all? { |coordinate| valid_coordinate?(coordinate) }
    return false unless coordinates.size == ship.length

    rows = coordinates.map { |coordinate| coordinate[0] } # Extract the row from the coordinate
    cols = coordinates.map { |coordinate| coordinate[1..-1].to_i } # Extract the column from the coordinate
    
    if rows.uniq.size == 1
      # All coordinates are in the same row, check if columns are consecutive
      cols.each_cons(2).all? { |a, b| b == a + 1 }
    elsif cols.uniq.size == 1
      # All coordinates are in the same column, check if rows are consecutive
      rows.each_cons(2).all? { |a, b| b.ord == a.ord + 1 }
    else
      false
    end
  end

  def place(ship, coordinates)
    return unless valid_placement?(ship, coordinates)

    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end
end
