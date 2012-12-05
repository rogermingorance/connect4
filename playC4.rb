#!/usr/bin/env ruby

require 'curses'
require './ConnectFour.rb'
require './ComputerPlayer.rb'

def initGameDisplay
	Curses.noecho
    Curses.init_screen
    Curses.curs_set 0
    Curses.stdscr.keypad true
     
    Curses.close_screen
    
    display(10, 0, "It is player X's turn")
    display(11, 0, 'Instructions:')
    display(12, 0, 'q=quit | r=restart | down=place | left/right=move')
    display(13, 0, "X = Human | O = Computer")
    display(15, 0, "Connect 4 by Roger Mingorance")
    display(16, 0, " " * 30)
end

def display(row, column, textToWrite)
    Curses.setpos row, column
    Curses.addstr textToWrite
end

def verifyWinner(game)
    messageLine = 10
    thankYouLine = 16
    if winner = game.winner
        display(messageLine, 0, "Player #{winner} has won!" + " " * 10)
        display(thankYouLine, 0, "Thank you for playing!")
    elsif game.draw?
        display(messageLine, 0, "No one won (sad) - game is a draw!")
        display(thankYouLine, 0, "Thank you for playing!")
    else
        display(messageLine, 0, "It is player #{game.getCurrentPlayer()}'s turn")
        return nil
    end
    
    # 'fix' instructions
    display(12, 18, " " * 35)
    
    loop do
		case Curses.getch
		when ?q, ?Q then return "q"
		when ?r, ?R then return "r"
		end
    end
    
end

def getLevel
	if ARGV[0] =~ /\A[0-9]+\Z/
		if ARGV[0].to_i >= 0 and ARGV[0].to_i <= 2
			return ARGV[0].to_i
		end
	end 
	
	puts "Program must be called with and dificulty level: 0, 1, 2"
	exit!
end

#start program
initGameDisplay()

height = 6
width = 7
game = ConnectFour.new(height, width)

dificultyLevel = getLevel()
computer = ComputerPlayer.new(dificultyLevel, height, width)

display(0, 0, game.returnBoard)

loop do
	#humans turn!
	successfullyPlayed = false
	case Curses.getch
	when Curses::Key::LEFT then game.move(-1)
	when Curses::Key::RIGHT then game.move(1)
	when Curses::Key::DOWN then successfullyPlayed = game.dropChip()
	when ?q, ?Q then break
	when ?r, ?R then
		game = ConnectFour.new
		display(0, 0, game.returnBoard)
		next
	end
    
    #print board after the play and verify if we have a winner
    display(0, 0, game.returnBoard)
    case verifyWinner(game)
    when "q" then break
    when "r" then
        game = ConnectFour.new
        initGameDisplay
        display(0, 0, game.returnBoard)
        next
    end


    #computer turn
	if successfullyPlayed == true then
		y= game.getFields()
		#display(18,0, y.to_s)
		x = computer.play(y)
		display(17, 0, x.to_s)
		game.dropChip(x)
		#game.dropChip(computer.play(game.getFields()))
		
		#print board after the play and verify if we have a winner
		display(0, 0, game.returnBoard)
		case verifyWinner(game)
		when "q" then break
		when "r" then
			game = ConnectFour.new
			initGameDisplay
			display(0, 0, game.returnBoard)
			next
		end
	end    
end