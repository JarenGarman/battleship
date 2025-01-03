require_relative 'cell'

class Board
  attr_reader :cells, :rows, :columns, :ships

  def initialize(dimensions = { length: 4, width: 4 })
    @rows = (65..(64 + dimensions[:length])).to_a.map(&:chr)
    @columns = (1..dimensions[:width]).to_a
    @cells = generate_board
    @cells_by_row = @cells.values.group_by { |cell| cell.coordinate[0] }
    @ships = []
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
    @ships << ship unless @ships.include?(ship)
  end

  def fire_upon(coordinate)
    cell = @cells[coordinate]
    if cell.fired_upon?
      "already_fired"
    else
      result = cell.fire_upon
      return result == :sunk ? "sunk" : "hit" if cell.ship
      "miss"
    end
  end

  def all_ships_sunk?
    @ships.all?(&:sunk?)
  end

  def render(show_ships = false)
    "  " + @columns.join(" ") + "\n" +
      @rows.map do |row|
        "#{row} " + @columns.map do |col|
          @cells["#{row}#{col}"].render(show_ships)
        end.join(" ")
      end.join("\n")
  end

  private

  def generate_board
    coords = []
    @rows.each do |row|
      @columns.each do |column|
        coords << "#{row}#{column}"
      end
    end
    coords.map { |coord| [coord, Cell.new(coord)] }.to_h
  end

  def are_consecutive?(coordinates)
    rows = coordinates.map { |coordinate| coordinate[0] }
    cols = coordinates.map { |coordinate| coordinate[1..-1].to_i }

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
end