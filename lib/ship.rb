class Ship
  attr_accessor :name, :size, :positions
  attr_reader :length, :health

  def initialize(name, size)
    @name = name
    @size = size
    @positions = []
    @length = size
    @health = size
  end

  def sunk?
    positions.empty? # If all positions are hit, the ship is sunk
  end

  def hit(position = nil)
    if position.nil? || positions.include?(position)
      positions.delete(position) if position
      @health -= 1
      puts "Hit at position #{position}" if position
    else
      puts "Miss at position #{position}"
    end
  end
end
