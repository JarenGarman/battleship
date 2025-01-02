require_relative 'board'
require_relative 'ship'

class User
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def place_ships(ships)
    ships.each do |ship|
      #puts "DEBUG: Placing ship #{ship.name}."
      coordinates = get_valid_coordinates(ship)
      @board.place(ship, coordinates)
      #puts "DEBUG: Ship #{ship.name} placed at #{coordinates.inspect}."  # Debugging output
      #puts "DEBUG: Current ships on board: #{@board.ships.map(&:name).inspect}"  # Debugging output
      render_board
    end
    # Additional debugging output after all ships are placed
    #puts "DEBUG: Player's board after placing ships:"
    #puts @board.render(true)
    #puts "DEBUG: Ships on player's board: #{@board.ships.map { |ship| { name: ship.name, sunk: ship.sunk? } }}"
  end

  def get_valid_coordinates(ship)
    #puts "Enter the squares for the #{ship.name} (#{ship.length} spaces):"
    coordinates = gets.chomp.split
    until @board.valid_placement?(ship, coordinates)
      #puts "Invalid coordinates. Please enter the squares for the #{ship.name} (#{ship.length} spaces):"
      coordinates = gets.chomp.split
    end
    coordinates
  end

  def render_board
    puts @board.render(true)
  end
end