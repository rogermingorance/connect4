#!/usr/bin/env ruby

class ConnectFour
	def initialize(height = 6, width = 7) #most common rows and columns
		@position = 1
		@rows = height
		@columns = width
		createBoard()
		@players = ['X', 'O']
		@player = @players.first
		@fields = Array.new(@columns * @rows).fill('.')
	end

	def createBoard
		@board = "|" + (' ' * @columns) + "|\n"
		@board += ("|" + "." * @columns + "|\n") * @rows
		@board += "=" * (@columns + 2) + "\n"
	end

	def returnBoard
		index = 0;
		board2 = @board.gsub(' ') do
			index += 1
			@position == index ? '*' : ' '
		end

		index = -1
		board2.gsub('.') do
			index += 1
			@fields[index]
		end
	end

	def move(offset)
	    @position += offset unless @position + offset < 1 || @position + offset > @columns
	end

	def setPosition(location)
		@position = location unless location < 1 || location > @columns
	end

	def dropChip(tempPosition = nil)
		if tempPosition == nil
			tempPosition = @position
		end
		@fields.each_index do |i|
			column = i % @columns
			if (column == tempPosition - 1)
				return false if @fields[i] != '.'
				next if @fields[i + @columns] == '.' unless i + @columns >= @fields.length
				@fields[i] = @player
				@player = next_player
				return true
			end
		end
		return false
	end

	def getCurrentPlayer
		return @player
	end

	def getFields
		return @fields
	end

	def winner
		# check horizontal
		@fields.each_slice(@columns) do |r|  # scan each row
			@players.each do |p| # check each player
				r.each_cons(4) do |c| # check each consecutive 4 elements
					players = c.uniq  # store the players placed in those 4 elements
					return p if players.length == 1 and players.index(p) != nil # winner if only one in 4
				end
			end
		end

		# check vertical
		@columns.times do |c|
			column = Array.new
			@rows.times do |r|
				index = c + (@columns * r)
				column.push @fields[index]
			end

			column.each_cons(4) do |i|
				player = i.uniq.join
				return player if player.length == 1 and @players.index(player) != nil
			end
		end

		# check diagonal left
		@fields.each_index do |f|
			fields = Array.new
			fields << @fields[f]
			(1..3).each do |t|
				next_index = f + ((@columns + 1) * t)
				next if next_index >= @fields.length or next_index % @columns == 0
				fields << @fields[next_index]
			end
			next if fields.length < 4
			player = fields.uniq
			return player[0] if player.length == 1 and @players.index(player[0]) != nil
		end

		#check diagonal right
		@fields.each_index do |f|
			fields = Array.new
			fields << @fields[f]
			(1..3).each do |t|
				next_index = f - ((@columns - 1) * t)
				next if next_index < 0 or next_index % @columns == 0
				fields << @fields[next_index]
			end
			next if fields.length < 4
			player = fields.uniq.join
			return player if player.length == 1 and @players.index(player) != nil
		end

		nil
	end

	def draw?
		@fields.index('.') == nil
	end

	private

	def next_player
		current_index = @players.index(@player)
		next_index = (current_index + 1) % @players.size
		return @players[next_index]
	end
end
