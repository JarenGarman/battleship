class Ship
  attr_reader :name, :size, :positions, :hits

  def initialize(name, size)
    @name = name
    @size = size
    @positions = []
    @hits = []
  end

  def length
    @size
  end

  def positions=(coordinates)
    @positions = coordinates
  end

  def sunk?
    puts "DEBUG: Checking if ship #{@name} is sunk: #{@positions.all? { |position| @hits.include?(position) }}" if DEBUG_MODE
    @positions.all? { |position| @hits.include?(position) }
  end

  def hit(position)
    if @positions.include?(position)
      @hits << position
      puts "Hit at position #{position}"
    else
      puts "Miss at position #{position}"
    end
  end
end
