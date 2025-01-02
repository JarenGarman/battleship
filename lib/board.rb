require_relative 'cell'

class Board
  attr_reader :cells, :rows, :columns, :ships

  def initialize(dimensions = { length: 4, width: 4 })
    @rows = (65..(64 + dimensions[:length])).to_a.map(&:chr)
    @columns = (1..dimensions[:width]).to_a
    @cells = generate_board
    @cells_by_row = @cells.values.group_by { |cell| cell.coordinate[0] }
    @ships = []
    puts "DEBUG: Board initialized with rows: #{@rows.inspect}, columns: #{@columns.inspect}, cells: #{@cells.keys.inspect}"
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
    @ships << ship
    puts "DEBUG: Ship #{ship.name} added to board. Total ships: #{@ships.size}"  # Debugging output
  end

  def fire_upon(coordinate)
    if valid_coordinate?(coordinate)
      puts "DEBUG: Firing upon #{coordinate}."
      @cells[coordinate].fire_upon
      puts "DEBUG: Cell #{coordinate} after firing: #{@cells[coordinate].render(true)}"
    else
      puts "Invalid coordinate: #{coordinate}"
    end
  end

  def all_ships_sunk?
    puts "DEBUG: Checking if all ships are sunk."
    @ships.each do |ship|
      puts "DEBUG: Ship #{ship.name} - sunk? #{ship.sunk?}"
    end
    all_sunk = @ships.all?(&:sunk?)
    puts "DEBUG: All ships sunk? #{all_sunk}"
    all_sunk
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
end