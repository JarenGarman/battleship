require_relative 'cell'

class Board
  DEBUG_MODE = false

  attr_accessor :ships
  attr_reader :cells, :rows, :columns

  def initialize(dimensions = { length: 4, width: 4 })
    @rows = (65..(64 + dimensions[:length])).to_a.map(&:chr)
    @columns = (1..dimensions[:width]).to_a
    @cells = generate_board
    @cells_by_row = @cells.values.group_by { |cell| cell.coordinate[0] }
    @ships = []
    @grid = Array.new(dimensions[:length]) { Array.new(dimensions[:width], ".") }
    puts "Board initialized with dimensions: #{dimensions.inspect}"
    puts "Cells: #{@cells.keys.inspect}"
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
    puts "Placing #{ship.name} at #{coordinates.inspect}" if DEBUG_MODE
    if valid_placement?(ship, coordinates)
      coordinates.each do |coordinate|
        @cells[coordinate].place_ship(ship)
      end
      ship.positions = coordinates
      @ships << ship
      coordinates.each { |pos| mark_grid(pos, "S") }
      puts "DEBUG: #{ship.name} placed at #{coordinates.inspect}" if DEBUG_MODE
    else
      puts "DEBUG: Invalid placement for #{ship.name} at #{coordinates.inspect}" if DEBUG_MODE
    end
  end

  def fire_upon(coordinate)
    if valid_coordinate?(coordinate)
      @cells[coordinate].fire_upon
      if @cells[coordinate].ship.nil?
        puts "DEBUG: Miss at #{coordinate}" if DEBUG_MODE
        return "miss"
      else
        puts "DEBUG: Hit at #{coordinate}" if DEBUG_MODE
        return "hit"
      end
    end
  end

  def mark_hit(coordinate)
    @cells[coordinate].fire_upon
  end

  def mark_miss(coordinate)
    @cells[coordinate].fire_upon
  end

  def cell_ship(coordinate)
    @cells[coordinate].ship
  end

  def cell_at(coordinate)
    @cells[coordinate]
  end

  def all_ships_sunk?
    puts "DEBUG: Checking if all ships are sunk: #{@ships.all?(&:sunk?)}" if DEBUG_MODE
    @ships.all?(&:sunk?)
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

  def mark_grid(position, marker)
    row = position[0].ord - 65
    col = position[1..-1].to_i - 1
    @grid[row][col] = marker
  end
end