#!/usr/bin/env ruby

require './ConnectFour.rb'

def displayGame(game)
	puts "Connect 4 by Roger Mingorance"
	puts game.printBoard() + "\n"
	puts "Instructions:\n"
	puts '[number] = place chip on respective column | q = quit | r = reset'
end

height = 6
width = 7
game = ConnectFour.new(height, width)
displayGame(game)

loop do
	playerMove = gets.chomp
	case playerMove #still needs to accomodate for ilegal values!
	when "q", "Q" then break;
	when "r", "R" then break;
	else game.dropChip(Integer(playerMove))
	end
	displayGame(game)

=begin
	1) Accept input from user -- modify board array value
	2) Display board
	3) Verify if game is won (break if won)
	4) Computer plays -- modify board array value
	5) Display board
	6) Verify if game is won (break if won)
=end

end
