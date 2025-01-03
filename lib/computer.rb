require_relative 'board'
require_relative 'ship'

class Computer
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def place_ships(ships)
    ships.each do |ship|
      coordinates = get_valid_coordinates(ship)
      @board.place(ship, coordinates)
    end
  end

  private

  def get_valid_coordinates(ship)
    loop do
      coordinates = generate_random_coordinates(ship.length)
      return coordinates if @board.valid_placement?(ship, coordinates)
    end
  end

  def generate_random_coordinates(length)
    rows = ('A'..'D').to_a
    columns = (1..4).to_a
    orientation = [:horizontal, :vertical].sample

    if orientation == :horizontal
      row = rows.sample
      start_col = columns.sample(length).sort
      start_col.map { |col| "#{row}#{col}" }
    else
      col = columns.sample
      start_row = rows.sample(length).sort
      start_row.map { |row| "#{row}#{col}" }
    end
  end
end
