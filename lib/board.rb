require_relative 'cell'

class Board
  attr_reader :cells, :ships

  def initialize(size = 4)
    @cells = create_cells(size)
    @ships = []
  end

  def render(show_ships = false)
    "  1 2 3 4\n" +
    "A #{row_render('A', show_ships)}\n" +
    "B #{row_render('B', show_ships)}\n" +
    "C #{row_render('C', show_ships)}\n" +
    "D #{row_render('D', show_ships)}\n"
  end

  def render_hidden
    "  1 2 3 4\n" +
    "A #{row_render('A', false)}\n" +
    "B #{row_render('B', false)}\n" +
    "C #{row_render('C', false)}\n" +
    "D #{row_render('D', false)}\n"
  end

  def place(ship, coordinates)
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
      ship.positions = coordinates
      @ships << ship
      true
    else
      false
    end
  end

  def fire_upon(coordinate)
    row, col = coordinate_to_indices(coordinate)
    if valid_coordinate?(coordinate) && @cells[coordinate].render != 'M' && @cells[coordinate].render != 'X'
      if @cells[coordinate].render == 'S'
        ship = find_ship_at(row, col)
        ship.hit(coordinate)
      end
      @cells[coordinate].fire_upon
    end
  end

  def cell_at(coordinate)
    @cells[coordinate]
  end

  def cell_ship(coordinate)
    @cells[coordinate].ship
  end

  def all_ships_sunk?
    @ships.all?(&:sunk?)
  end

  public

  def valid_placement?(ship, coordinates)
    return false if coordinates.size != ship.length

    coordinates.each do |coordinate|
      return false unless valid_coordinate?(coordinate) && @cells[coordinate].empty?
    end

    rows = coordinates.map { |coord| coord[0] }
    cols = coordinates.map { |coord| coord[1..-1].to_i }

    rows.uniq.size == 1 || cols.uniq.size == 1
  end

  def valid_coordinate?(coordinate)
    @cells.key?(coordinate)
  end

  def coordinate_to_indices(coordinate)
    row = coordinate[0].ord - 'A'.ord
    col = coordinate[1..-1].to_i - 1
    [row, col]
  end

  private

  def row_render(row, show_ships)
    (1..4).map { |col| @cells["#{row}#{col}"].render(show_ships) }.join(" ")
  end

  def create_cells(size)
    ("A".."D").flat_map do |row|
      (1..size).map do |col|
        coord = "#{row}#{col}"
        [coord, Cell.new(coord)]
      end
    end.to_h
  end

  def find_ship_at(row, col)
    @ships.find { |ship| ship.positions.include?("#{('A'.ord + row).chr}#{col + 1}") }
  end
end