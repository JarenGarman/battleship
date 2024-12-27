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
    coordinates.all? { |coordinate| valid_coordinate?(coordinate) } &&
      coordinates.size == ship.length &&
      coordinates.all? { |coordinate| @cells[coordinate].empty? } &&
      are_consecutive(coordinates)
  end

  def place(ship, coordinates)
    return unless valid_placement?(ship, coordinates)

    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render(debug = false)
    render_rows_array = []
    @cells.values.group_by { |cell| cell.coordinate[0] }.each do |row, coord_array|
      render_coords_array = coord_array.map do |coord|
        coord.render(debug)
      end
      render_rows_array << "#{row} #{render_coords_array.join(' ')} \n"
    end
    "  1 2 3 4 \n#{render_rows_array.join}"
  end

  private

  def are_consecutive(coordinates)
    rows = coordinates.map { |coordinate| coordinate[0] }.sort
    cols = coordinates.map { |coordinate| coordinate[1] }.sort
    (rows.uniq.size == 1 && all_consecutive(cols)) || (cols.uniq.size == 1 && all_consecutive(rows))
  end

  def all_consecutive(coords)
    coords.each_cons(2).all? { |current_coord, next_coord| next_coord.ord == current_coord.ord + 1 }
  end
end
