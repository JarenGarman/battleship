require_relative 'computer'

# Play the game!
class Game
  # The start method is the entry point for the game. It displays the main menu.
  def start
    puts 'Welcome to BATTLESHIP'
    puts "Enter 'p' to play. Enter 'q' to quit."
    handle_main_menu_input
  end

  private # used internally by the Game class.

  # reads user input and determines the next steps based on the input.
  def handle_main_menu_input
    case gets.chomp.downcase
    when 'p'
      start_game
    when 'q'
      puts 'Quitting game...'
      exit
    else
      puts "Invalid input. Please enter 'p' to play or 'q' to quit."
      handle_main_menu_input
    end
  end

  # called when the user chooses to start the game. contains the game logic/calls the end_game method when over.
  def start_game
    puts 'Starting game...'
    cruiser = Ship.new('Cruiser', 3)
    submarine = Ship.new('Submarine', 2)
    @ships = [cruiser, submarine]
    cpu = Computer.new
    cpu.place_ships(@ships)
    puts 'I have laid out my ships on the grid.'
    puts 'You now need to lay out your two ships.'
    puts 'The Cruiser is three units long and the Submarine is two units long.'
    end_game
  end

  def end_game
    puts 'Game over. Returning to main menu...'
    start
  end
end
