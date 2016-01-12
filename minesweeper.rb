class ValueError < StandardError
  def initialize(msg = "Argument contains errors")
    super
  end
end

class Board
  BLANK = " "
  MINE = "*"

  def self.transform(rows)
    @@board = rows
    raise ValueError if invalid_arguments?

    num_cols = @@board[0].length - 2
    num_rows = @@board.length - 2

    (1..num_cols).each do |x|
      (1..num_rows).each do |y|
        Board[x,y] = num_adjacent_mines(x,y) if Board[x,y] == BLANK
      end
    end
    @@board
  end

  private

  def self.num_adjacent_mines(x,y)
    #return blank space if answer is zero
    adjacent = [[-1,-1],[0,-1],[1,-1],[-1,0],[1,0],[-1,1],[0,1],[1,1]]
    count = 0
    adjacent.each do |pos|
      count += 1 if Board[x + pos[0], y + pos[1]] == MINE
    end
    return BLANK if count == 0
    count.to_s
  end

  def self.[](x,y)
    @@board[y][x]
  end

  def self.[]=(x,y, value)
    @@board[y][x] = value
    # puts get_char_at(x,y)
  end

  def self.to_s
    @@board.each do |row|
      puts row
    end
  end

  def self.invalid_arguments?
    return true if !all_same_length?
    return true if !top_and_bottom_valid?
    return true if !has_pipe_borders?
    return true if !all_valid_chars?
    false
  end

  def self.all_same_length?
    length = @@board[0].length
    @@board.clone.keep_if { |row| row.length != length }.empty?
  end

  def self.top_and_bottom_valid?
    columns = @@board[0].length - 2
    should_be = "+#{"-" * columns}+"
    @@board.first == should_be && @@board.last == should_be
  end

  def self.has_pipe_borders?
    center_rows = @@board.slice(1..-2) # remove first and last
    center_rows.delete_if{ |row| row[0] == "|" && row[-1] == "|" }.empty?
  end

  def self.all_valid_chars?
    flat = @@board.join
    flat.delete("+*| -") == ""
  end
end
