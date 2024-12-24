# Create a board that contains Cells for the game
class Board
  attr_reader :cells

  def initialize
    @cells = {}
  end
end
