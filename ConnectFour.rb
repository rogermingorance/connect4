#!/usr/bin/env ruby

class ConnectFour
	def initialize(height = 6, width = 7) #most common rows and columns
		@rows = height
		@columns = width
		createBoard()
		@players = ['X', 'O']
		@player = @players.first
		@fields = Array.new(@columns * @rows).fill('.')
	end

	def createBoard
		@board = "|" + (1..@columns).to_a.join('') + "|\n"
		@board += ("|" + "." * @columns + "|\n") * @rows
		@board += "-" * (@columns + 2) + "\n"
	end

	def printBoard
		index = -1
		@board.gsub('.') do
			index += 1
			@fields[index]
		end
    end

	def dropChip(position)
		@fields.each_index do |i|
			column = i % @columns
			if (column == position - 1)
				next if @fields[i + @columns] == '.' unless i + @columns >= @fields.length
				break if @fields[i] != '.'
				@fields[i] = @player
				next_player
				break;
			end
		end
	end

	def next_player
		current_index = @players.index(@player)
		next_index = (current_index + 1) % @players.size
		@player = @players[next_index]
	end
end
