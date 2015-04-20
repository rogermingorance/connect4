#
# Docs
#
require 'curses'
require './connect_four.rb'
require './computer_player.rb'

def init_game_display
  Curses.noecho
  Curses.init_screen
  Curses.curs_set 0
  Curses.stdscr.keypad true

  Curses.close_screen

  display(10, 0, "It is player X's turn")
  display(11, 0, 'Instructions:')
  display(12, 0, 'q=quit | r=restart | down=place | left/right=move')
  display(13, 0, 'X = Human | O = Computer')
  display(15, 0, 'Connect 4 by Roger Mingorance')
  display(16, 0, ' ' * 30)
end

def display(row, column, textToWrite)
  Curses.setpos row, column
  Curses.addstr textToWrite
end

def verify_winner(game)
  message_line = 10
  thank_you_line = 16
  if winner = game.winner
    display(message_line, 0, "Player #{winner} has won!" + ' ' * 10)
    display(thank_you_line, 0, 'Thank you for playing!')
  elsif game.draw?
    display(message_line, 0, 'No one won (sad) - game is a draw!')
    display(thank_you_line, 0, 'Thank you for playing!')
  else
    display(thank_you_line, 0, "It is player #{game.player}'s turn")
    return nil
  end

  # 'fix' instructions
  display(12, 18, ' ' * 35)

  loop do
    case Curses.getch
    when 'q', 'Q' then return 'q'
    when 'r', 'R' then return 'r'
    end
  end
end

def fetch_level
  if ARGV[0] =~ /\A[0-9]+\Z/
    if ARGV[0].to_i >= 0 && ARGV[0].to_i <= 2
      return ARGV[0].to_i
    end
  end

  puts 'Program must be called with and dificulty level: 0, 1, 2'
  exit
end

# start program
init_game_display

height = 6
width = 7
game = ConnectFour.new(height, width)

dificulty_level = fetch_level
computer = ComputerPlayer.new(dificulty_level, height, width)

display(0, 0, game.return_board)

loop do # rubocop:disable Style/Next
  # humans turn!
  successfully_played = false
  case Curses.getch
  when Curses::Key::LEFT then game.move(-1)
  when Curses::Key::RIGHT then game.move(1)
  when Curses::Key::DOWN then successfully_played = game.drop_chip
  when 'q', 'Q' then break
  when 'r', 'R' then
    game = ConnectFour.new(height, width)
    display(0, 0, game.return_board)
    next
  end

  # print board after the play and verify if we have a winner
  display(0, 0, game.return_board)
  case verify_winner(game)
  when 'q' then break
  when 'r' then
    game = ConnectFour.new(height, width)
    init_game_display
    display(0, 0, game.return_board)
    next
  end

  # computer turn
  if successfully_played == true
    y = game.fields
    # display(18,0, y.to_s)
    x = computer.play(y)
    # display(20, 0, x.to_s)
    game.drop_chip(x)
    # game.drop_chip(computer.play(game.fields()))

    # print board after the play and verify if we have a winner
    display(0, 0, game.return_board)
    case verify_winner(game)
    when 'q' then break
    when 'r' then
      game = ConnectFour.new(height, width)
      init_game_display
      display(0, 0, game.return_board)
      next
    end
  end
end
