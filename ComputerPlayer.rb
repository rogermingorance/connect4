#!/usr/bin/env ruby

class ComputerPlayer
	def initialize(level, height, width)
		@level = level
		@rows = height
		@columns = width
		@fields = Array.new()
	end
	
	def play(fields)
		@fields = fields
		if @level == 0 
			positionToPlay = randomPlay
		elsif @level == 1
			@points = Array.new(@columns * @rows).fill(0)
			calculatePointsByDefense
			positionToPlay = pickHighestCalculatedNumber
		elsif @level == 2
			@points = Array.new(@columns * @rows).fill(0)
			calculatePointsByDefense
			calculatePointsByOffense
			positionToPlay = pickHighestCalculatedNumber
		end
		return positionToPlay
	end
	
	def calculatePointsByDefense
		opponent = "X"
		empty = "."
		
		# - check on right horizontal
		currentRow = 0
		currentColumn = 0
		for consecutive in (1..3) 
			@fields.each_slice(@columns) do |r|  # scan each row
				r.each_cons(consecutive) do |c|
					if c.uniq.length == 1 and c.uniq[0] == opponent and r[currentColumn+consecutive] == empty
						#p = (currentRow*@columns)+(currentColumn+consecutive)
						#return {'position' => p, 'row' => currentRow, 'col' => currentColumn}
						@points[(currentRow*@columns)+(currentColumn+consecutive)] += 2**consecutive
					end
					currentColumn += 1
				end
				currentColumn = 0
				currentRow +=1
			end
			currentRow = 0
		end
		
		# - check on the left horizontal
		currentRow = 0
		currentColumn = 0
		for consecutive in (1..3) 
			@fields.each_slice(@columns) do |r|  # scan each row
				r.each_cons(consecutive) do |c|
					if c.uniq.length == 1 and c.uniq[0] == opponent and r[currentColumn-1] == empty
						#p = (currentRow*@columns)+(currentColumn+consecutive)
						#return {'position' => p, 'row' => currentRow, 'col' => currentColumn}
						@points[(currentRow*@columns)+(currentColumn-1)] += 2**consecutive
					end
					currentColumn += 1
				end
				currentColumn = 0
				currentRow +=1
			end
			currentRow = 0
		end
		
		# - check on top (vertical)
		currentRow = 0
		currentColumn = 0
		@columns.times do |c|
			column = Array.new
			@rows.times do |r|
				index = c + (@columns * r)
				column.push @fields[index]
			end

			for consecutive in (1..3)
				column.each_cons(consecutive) do |i|
					if i.uniq.length == 1 and i.uniq[0] == opponent and column[currentRow-1] == empty
						@points[((currentRow-1)*@columns)+(currentColumn)] += 2**consecutive
					end
					currentRow += 1
				end
				currentRow = 0
			end
			currentColumn += 1
		end
		
		# - check 2 diagonal, top + right
		firstIndex = @columns * 2
		lastIndex = (@columns * @rows) - 3
		for index in (firstIndex..lastIndex)
			next if index%@columns > @columns-4 #position is to close to the right edge of board
			if @fields[index] == opponent and @fields[index-@columns+1] == opponent and @fields[index-(@columns*2)+2] == empty
				@points[index-(@columns*2)+2] += 4
			end
		end
		
		# - check 3 diagonal, top + right
		firstIndex = @columns * 3
		lastIndex = (@columns * @rows) - 4
		for index in (firstIndex..lastIndex)
			next if index%@columns > @columns-4 #position is to close to the right edge of board
			if @fields[index] == opponent and @fields[index-@columns+1] == opponent and \
					 fields[index-(@columns*2)+2] ==  opponent and @fields[index-(@columns*3)+3] == empty
				@points[index-(@columns*2)+2] += 8
			end
		end
		
		# - check 2 diagonal, top + left
		firstIndex = (@columns * 2) + 2
		lastIndex = (@columns * @rows) - 1
		for index in (firstIndex..lastIndex)
			next if index%@columns < 3 #position is to close to the left edge of board
			if @fields[index] == opponent and @fields[index-@columns-1] == opponent and @fields[index-(@columns*2)-2] == empty
				@points[index-(@columns*2)-2] += 4
			end
		end
		
		# - check 3 diagonal, top + left
		firstIndex = @columns * 3
		lastIndex = (@columns * @rows) - 1
		for index in (firstIndex..lastIndex)
			next if index%@columns < 3 #position is to close to the right edge of board
			if @fields[index] == opponent and @fields[index-@columns-1] == opponent and \
					 @fields[index-(@columns*2)-2] ==  opponent and @fields[index-(@columns*3)-3] == empty
				@points[index-(@columns*2)+2] += 8
			end
		end
		
	
		return true
	end
	
	def calculatePointsByOffense
		return
	end
	
	def randomPlay
		tempPosition = rand(@rows)
		
		loop do
			max = @fields.length() - 1
		
			while max >= tempPosition do
				if (max % @columns) != tempPosition
					max -= 1
					next
				end
				if @fields[max] == "."
					return tempPosition + 1
				else
					max -= 1
					next
				end
			end
			
			tempPosition = rand(@rows)
		end	
	end
	
	private
	
	def pickHighestCalculatedNumber
		#reset points on spaces where the space underneath is unoccupied
		@points.each_index do |i|
			next if i > (@rows * @columns) - 2 #bottom row on board, no need to test
			@points[i] = 0 if @fields[i+@columns] == "."
		end
		
		max = @points.max()
		
		#return @points
		
		temp = Array.new()
		@points.each_with_index do |item, index|
			if item == max
				temp << index
			end
		end
		return (temp[rand(temp.length())] % @columns) + 1
	end
	
end
	