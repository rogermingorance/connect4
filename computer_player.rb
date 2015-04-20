#
# computer_player
#
class ComputerPlayer
  def initialize(level, height, width)
    @level = level
    @rows = height
    @columns = width
    @fields = []
  end

  def play(fields)
    @fields = fields
    if @level == 0
      position_play = random_play
    elsif @level == 1
      @points = Array.new(@columns * @rows).fill(0)
      calculate_points_defense
      position_play = pick_highest_calculated_number
    elsif @level == 2
      @points = Array.new(@columns * @rows).fill(0)
      calculate_points_defense
      calculate_points_offense
      position_play = pick_highest_calculated_number
    end
    position_play
  end

  def calculate_points_defense # rubocop:disable Metrics/MethodLength
    opponent = 'X'
    empty = '.'

    # - check horizontal right/left
    current_row = 0
    current_column = 0
    (1..3).each do |consecutive|
      @fields.each_slice(@columns) do |r|  # scan each row
        r.each_cons(consecutive) do |c|
          if c.uniq.length == 1 && c.uniq[0] == opponent
            if r[current_column + consecutive] == empty # on the right
              @points[(current_row * @columns) + (current_column + consecutive)] += 2**consecutive
            end
            if r[current_column - 1] == empty # on the left
              @points[(current_row * @columns) + (current_column - 1)] += 2**consecutive
            end
          end
          current_column += 1
        end
        current_column = 0
        current_row += 1
      end
      current_row = 0
    end

    # - check on top (vertical)
    current_row = 0
    current_column = 0
    @columns.times do |c|
      column = []
      @rows.times do |r|
        index = c + (@columns * r)
        column.push @fields[index]
      end

      (1..3).each do |consecutive|
        column.each_cons(consecutive) do |i|
          if i.uniq.length == 1 && i.uniq[0] == opponent && column[current_row - 1] == empty
            @points[((current_row - 1) * @columns) + (current_column)] += 2**consecutive
          end
          current_row += 1
        end
        current_row = 0
      end
      current_column += 1
    end

    # - check 2 diagonal, top + right
    first_index = @columns * 3
    last_index = (@columns * @rows) - 4
    (first_index..last_index).each do |index|
      next if index % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[index] == opponent && @fields[index - @columns + 1] == opponent && \
         @fields[index - (@columns * 2) + 2] == empty
        @points[index - (@columns * 2) + 2] += 4
      end
    end

    # - check 3 diagonal, top + right
    first_index = @columns * 3
    last_index = (@columns * @rows) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == opponent && @fields[xindex - @columns + 1] == opponent && \
         @fields[xindex - (@columns * 2) + 2] ==  opponent && @fields[xindex - (@columns * 3) + 3] == empty
        @points[xindex - (@columns * 2) + 2] += 8
      end
    end

    # - check 2 diagonal, top + left
    first_index = (@columns * 3) + 3
    last_index = (@columns * @rows) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == opponent && @fields[xindex - @columns - 1] == opponent && \
         @fields[xindex - (@columns * 2) - 2] == empty
        @points[xindex - (@columns * 2) - 2] += 4
      end
    end

    # - check 3 diagonal, top + left
    first_index = (@columns * 3) + 3
    last_index = (@columns * @rows) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == opponent && @fields[xindex - @columns - 1] == opponent && \
         @fields[xindex - (@columns * 2) - 2] ==  opponent && @fields[xindex - (@columns * 3) - 3] == empty
        @points[xindex - (@columns * 2) + 2] += 8
      end
    end

    # - check 2 diagonal, down + right
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == opponent && @fields[xindex + @columns + 1] == opponent && \
         @fields[xindex + (@columns * 2) + 2] == empty
        @points[xindex + (@columns * 2) + 2] += 4
      end
    end

    # - check 3 diagonal, down + right
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == opponent && @fields[xindex + @columns + 1] == opponent && \
         @fields[xindex + (@columns * 2) + 2] == opponent && @fields[xindex + (@columns * 3) + 3] == empty
        @points[xindex + (@columns * 3) + 3] += 8
      end
    end

    # - check 2 diagonal, down + left
    first_index = 3
    last_index = (@columns * (@rows - 3)) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == opponent && @fields[xindex + @columns - 1] == opponent && \
         @fields[xindex + (@columns * 2) - 2] == empty
        @points[xindex + (@columns * 2) + 2] += 4
      end
    end

    # - check 3 diagonal, down + left
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == opponent && @fields[xindex + @columns - 1] == opponent && \
         @fields[xindex + (@columns * 2) - 2] == opponent && @fields[xindex + (@columns * 3) - 3] == empty
        @points[xindex + (@columns * 3) - 3] += 8
      end
    end

    true
  end

  def calculate_points_offense # rubocop:disable Metrics/MethodLength
    me = 'O'
    empty = '.'

    # - check horizontal right/left
    current_row = 0
    current_column = 0
    (1..3).each do |consecutive|
      @fields.each_slice(@columns) do |r|  # scan each row
        r.each_cons(consecutive) do |c|
          if c.uniq.length == 1 && c.uniq[0] == me
            if r[current_column + consecutive] == empty # on the right
              if consecutive == 3
                @points[(current_row * @columns) + (current_column + consecutive)] += 16
              else
                @points[(current_row * @columns) + (current_column + consecutive)] += 2**consecutive
              end
            end
            if r[current_column - 1] == empty # on the left
              if consecutive == 3
                @points[(current_row * @columns) + (current_column - 1)] += 16
              else
                @points[(current_row * @columns) + (current_column - 1)] += 2**consecutive
              end
            end
          end
          current_column += 1
        end
        current_column = 0
        current_row += 1
      end
      current_row = 0
    end

    # - check on top (vertical)
    current_row = 0
    current_column = 0
    @columns.times do |c|
      column = []
      @rows.times do |r|
        index = c + (@columns * r)
        column.push @fields[index]
      end

      (1..3).each do |consecutive|
        column.each_cons(consecutive) do |i|
          if i.uniq.length == 1 && i.uniq[0] == me && column[current_row - 1] == empty
            if consecutive == 3
              @points[((current_row - 1) * @columns) + (current_column)] += 16
            else
              @points[((current_row - 1) * @columns) + (current_column)] += 2**consecutive
            end
          end
          current_row += 1
        end
        current_row = 0
      end
      current_column += 1
    end

    # - check 2 diagonal, top + left
    first_index = (@columns * 2) + 2
    last_index = (@columns * @rows) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == me && @fields[xindex - @columns - 1] == me && @fields[xindex - (@columns * 2) - 2] == empty
        @points[xindex - (@columns * 2) - 2] += 4
      end
    end

    # - check 3 diagonal, top + left
    first_index = @columns * 3
    last_index = (@columns * @rows) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == me && @fields[xindex - @columns - 1] == me && \
         @fields[xindex - (@columns * 2) - 2] ==  me && @fields[xindex - (@columns * 3) - 3] == empty
        @points[xindex - (@columns * 2) + 2] += 16
      end
    end

    # - check 2 diagonal, top + right
    first_index = @columns * 3
    last_index = (@columns * @rows) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == me && @fields[xindex - @columns - 1] == me && @fields[xindex - (@columns * 2) - 2] == empty
        @points[xindex - (@columns * 2) - 2] += 4
      end
    end

    # - check 3 diagonal, top + right
    first_index = @columns * 3
    last_index = (@columns * @rows) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == me && @fields[xindex - @columns - 1] == me && \
         @fields[xindex - (@columns * 2) - 2] ==  me && @fields[xindex - (@columns * 3) - 3] == empty
        @points[xindex - (@columns * 2) + 2] += 16
      end
    end

    # - check 2 diagonal, down + right
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == me && @fields[xindex + @columns + 1] == me && \
         @fields[xindex + (@columns * 2) + 2] == empty
        @points[xindex + (@columns * 2) + 2] += 4
      end
    end

    # - check 3 diagonal, down + right
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns > @columns - 4 # position is to close to the right edge of board
      if @fields[xindex] == me && @fields[xindex + @columns + 1] == me && \
         @fields[xindex + (@columns * 2) + 2] == me && @fields[xindex + (@columns * 3) + 3] == empty
        @points[xindex + (@columns * 3) + 3] += 16
      end
    end

    # - check 2 diagonal, down + left
    first_index = 3
    last_index = (@columns * (@rows - 3)) - 1
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == me && @fields[xindex + @columns - 1] == me && \
         @fields[xindex + (@columns * 2) - 2] == empty
        @points[xindex + (@columns * 2) + 2] += 4
      end
    end

    # - check 3 diagonal, down + left
    first_index = 0
    last_index = (@columns * (@rows - 3)) - 4
    (first_index..last_index).each do |xindex|
      next if xindex % @columns < 3 # position is to close to the left edge of board
      if @fields[xindex] == me && @fields[xindex + @columns - 1] == me && \
         @fields[xindex + (@columns * 2) - 2] == me && @fields[xindex + (@columns * 3) - 3] == empty
        @points[xindex + (@columns * 3) - 3] += 16
      end
    end

    true
  end

  def random_play
    temp_position = rand(@rows)

    loop do
      max = @fields.length - 1

      while max >= temp_position
        if (max % @columns) != temp_position
          max -= 1
          next
        end
        if @fields[max] == '.'
          return temp_position + 1
        else
          max -= 1
          next
        end
      end

      temp_position = rand(@rows)
    end
  end

  private

  def pick_highest_calculated_number
    # reset points on spaces where the space underneath is unoccupied
    # also, reset points if space is un-occupied
    @points.each_index do |i|
      @points[i] = 0 if @fields[i] != '.'
      next if i >= (@rows - 1) * @columns # bottom row on board, no need to test
      @points[i] = 0 if @fields[i + @columns] == '.'
    end

    max = @points.max

    # return @points

    temp = []
    @points.each_with_index do |item, index|
      if item == max
        temp << index
      end
    end

    (temp[rand(temp.length)] % @columns) + 1
  end
end
