require_relative 'cell'

# Create a board that contains Cells for the game
class Board
  attr_reader :cells, :rows, :columns

  def initialize(dimensions = { length: 4, width: 4 })
    @rows = (65..(64 + dimensions[:length])).to_a.map(&:chr)
    @columns = (1..dimensions[:width]).to_a
    @cells = generate_board
  end

  def valid_coordinate?(coordinate)
    @cells.key?(coordinate)
  end

  def valid_placement?(ship, coordinates)
    coordinates.all? { |coordinate| valid_coordinate?(coordinate) } &&
      coordinates.size == ship.length &&
      coordinates.all? { |coordinate| @cells[coordinate].empty? } &&
      are_consecutive?(coordinates)
  end

  def place(ship, coordinates)
    return unless valid_placement?(ship, coordinates)

    coordinates.each do |coordinate|
      @cells[coordinate].place_ship(ship)
    end
  end

  def render(debug = false)
    top_line = [' ', @columns, "\n"].flatten.join(' ')
    render_rows_array = @rows.map do |row|
      "#{row} #{@cells.select { |coord| coord[0] == row }.values.map { |cell| cell.render(debug) }.join(' ')} \n"
    end
    top_line + render_rows_array.join
  end

  private

  def generate_board
    coords = []
    @rows.each do |row|
      @columns.each do |column|
        coords << "#{row}#{column}"
      end
    end
    cells = {}
    coords.each { |coord| cells[coord] = Cell.new(coord) }
    cells
  end

  def are_consecutive?(coordinates)
    rows = coordinates.map { |coordinate| coordinate[0] }.sort
    cols = coordinates.map { |coordinate| coordinate[1] }.sort
    (rows.uniq.size == 1 && all_consecutive?(cols)) || (cols.uniq.size == 1 && all_consecutive?(rows))
  end

  def all_consecutive?(coords)
    coords.each_cons(2).all? { |current_coord, next_coord| next_coord.ord == current_coord.ord + 1 }
  end
end
