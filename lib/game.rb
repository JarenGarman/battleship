class Game
  def initialize
    @game_over = false
  end

  def display_main_menu
    puts "Welcome to BATTLESHIP"
    puts "Enter 'p' to play. Enter 'q' to quit."
    handle_main_menu_input
  end

  private

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