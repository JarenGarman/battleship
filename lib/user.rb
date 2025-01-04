require_relative 'ship'
require_relative 'board'

class User
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def place_ships(ships)
    ships.each do |ship|
      coordinates = get_valid_coordinates(ship)
      @board.place(ship, coordinates)
      render_board
      puts "DEBUG: Player ships after placing #{ship.name}: #{@board.ships.map(&:positions).inspect}"
    end
  end

  def get_valid_coordinates(ship)
    puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
    input = gets.chomp
    coordinates = parse_coordinates(input)
    until @board.valid_placement?(ship, coordinates)
      puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces):"
      input = gets.chomp
      coordinates = parse_coordinates(input)
    end
    coordinates
  end

  def parse_coordinates(input)
    coordinates = input.split.map { |coord| convert_to_grid(coord.upcase) }
    puts "Parsed coordinates: #{coordinates.inspect}"
    coordinates
  end

  def convert_to_grid(coordinate)
    row = coordinate[0]
    col = coordinate[1..-1].to_i
    "#{row}#{col}"
  end

  def render_board
    puts @board.render(true)
  end
end