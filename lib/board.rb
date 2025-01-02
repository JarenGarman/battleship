require_relative 'cell'

# Create a board that contains Cells for the game
class Board
  attr_reader :cells, :rows, :columns

  def initialize(dimensions = { length: 4, width: 4 })
    @rows = (65..(64 + dimensions[:length])).to_a.map(&:chr)
    @columns = (1..dimensions[:width]).to_a
    @cells = generate_board
    @cells_by_row = @cells.values.group_by { |cell| cell.coordinate[0] }
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

  def render(show_ships = false)
    rendered_board = "  " + @columns.join(" ") + "\n"
    @rows.each do |row|
      rendered_board += row + " "
      @columns.each do |column|
        coordinate = "#{row}#{column}"
        rendered_board += @cells[coordinate].render(show_ships) + " "
      end
      rendered_board.rstrip!
      rendered_board += "\n"
    end
    rendered_board.rstrip
  end

  def fire_upon(coordinate)
    if valid_coordinate?(coordinate)
      @cells[coordinate].fire_upon
      return @cells[coordinate].render
    end
    "invalid"
  end

  def all_ships_sunk?
    @cells.values.all? { |cell| cell.empty? || cell.ship.sunk? }
  end

  private

  def generate_board
    board = {}
    @rows.each do |row|
      @columns.each do |column|
        coordinate = "#{row}#{column}"
        board[coordinate] = Cell.new(coordinate)
      end
    end
    board
  end
end
