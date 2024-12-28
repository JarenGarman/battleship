class Game
  def initialize
    @game_over = false
  end
  # The display_main_menu method is the entry point for the game. It displays the main menu and handles user input.
  def display_main_menu
    puts "Welcome to BATTLESHIP"
    puts "Enter 'p' to play. Enter 'q' to quit."
    handle_main_menu_input
  end

  private #used internally by the Game class.

  # reads user input and determines the next steps based on the input.
  def handle_main_menu_input
    input = gets.chomp.downcase
    case input
    when 'p'
      start_game
    when 'q'
      puts "Quitting game..."
      exit
    else
      puts "Invalid input. Please enter 'p' to play or 'q' to quit."
      display_main_menu
    end
  end

  # called when the user chooses to start the game. contains the game logic/calls the end_game method when over.
  def start_game
    puts "Starting game..."
    # Add logic to start the game
    end_game
  end

  def end_game
    puts "Game over. Returning to main menu..."
    display_main_menu
  end
end