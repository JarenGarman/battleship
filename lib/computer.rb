require_relative 'board'

# The enemy of the player
class Computer
  attr_reader :board

  def initialize
    @board = Board.new
  end
end
