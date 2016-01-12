class BattleshipGame
  attr_accessor :human, :computer

  def initialize
    @human = Player.new('Your')
    @computer = Player.new('Computer')
    game_loop
  end

  def display_boards
    display_board(@human)
    display_board(@computer)
  end

  def display_board(player)
    puts "#{player.name} Board"
    puts player.board.to_s
    puts "#{player.board.display_ship_stats}"
  end

  def prompt_move
    print "Select a square (x, y) to fire: "
    loop do
      response = gets.chomp
      square = response.split(",").map!(&:strip).map!(&:to_i)
      if square.length == 2 && !square.include?(0)
        break if @computer.board.drop_bomb(square[0], square[1])
      end 
      puts "Invalid selection! Try again: "
    end
  end

  def computer_turn
    loop do
      x = rand(Board::GRID_SIZE)+1
      y = rand(Board::GRID_SIZE)+1
      break if @human.board.drop_bomb(x, y)
    end
  end

  def game_over?
    @human.board.all_ships_sunk? || @computer.board.all_ships_sunk?
  end

  def display_winner
    if @human.board.all_ships_sunk?
      puts "Game over!  #{@computer.name} wins!"
    elsif @computer.board.all_ships_sunk?
      puts "Game over!  You win!"
    end  
  end

  def clear
    system 'clear'
  end

  def game_loop
    loop do
      clear
      display_boards
      prompt_move
      break if game_over?
      computer_turn
      break if game_over?
    end
    display_boards
    display_winner
  end
end

class Player
  attr_accessor :name, :board

  def initialize(name)
    @name = name
    @board = Board.new
  end
end

class Board
  GRID_SIZE = 5
  HIT_MARK = "X"
  MISS_MARK = "/"
  BLANK_MARK = " "
  attr_accessor :ships, :grid

  def initialize
    initialize_grid
    create_ships
  end

  # def draw_ships
  #   @ships.each do |ship|
  #     ship.coords.each do |loc|
  #       self[loc[0],loc[1]] = "O"
  #     end
  #   end
  # end

  def initialize_grid
    @grid = Array.new(GRID_SIZE){Array.new(GRID_SIZE)}
    (1..GRID_SIZE).each do |row|
      (1..GRID_SIZE).each do |column|
        self[row,column] = BLANK_MARK
      end
    end
  end

  def to_s
    puts "    1   2   3   4   5"
    puts "  +---+---+---+---+---+"
    puts "1 | #{self[1,1]} | #{self[2,1]} | #{self[3,1]} | #{self[4,1]} | #{self[5,1]} |"
    puts "  +---+---+---+---+---+"
    puts "2 | #{self[1,2]} | #{self[2,2]} | #{self[3,2]} | #{self[4,2]} | #{self[5,2]} |"
    puts "  +---+---+---+---+---+"
    puts "3 | #{self[1,3]} | #{self[2,3]} | #{self[3,3]} | #{self[4,3]} | #{self[5,3]} |"
    puts "  +---+---+---+---+---+"
    puts "4 | #{self[1,4]} | #{self[2,4]} | #{self[3,4]} | #{self[4,4]} | #{self[5,4]} |"
    puts "  +---+---+---+---+---+"
    puts "5 | #{self[1,5]} | #{self[2,5]} | #{self[3,5]} | #{self[4,5]} | #{self[5,5]} |"
    puts "  +---+---+---+---+---+"
  end

  def create_ships
    @ships = []
    @ships << Ship.new("Destroyer", find_spots(1))
    @ships << Ship.new("Cruiser", find_spots(2))
    @ships << Ship.new("Battleship", find_spots(3))
  end

  def find_spots(num_spots)
    loop do
      spots = []
      pick_y, pick_x = 0, 0

      loop do
        pick_x = rand(GRID_SIZE)+1
        pick_y = rand(GRID_SIZE)+1
        if spot_unoccupied?(pick_x, pick_y)
          spots << [pick_x, pick_y]
          break
        end
      end

      return spots if num_spots == spots.length
      x_offset = 0
      y_offset = 0
      sign = [-1,1].sample
      rand(2)+1 == 1 ? x_offset = sign : y_offset = sign

      loop do
        (1..num_spots-1).each do |counter|
          px = pick_x + (x_offset * counter)
          py = pick_y + (y_offset * counter)
          break if out_of_range?(px, py) || !spot_unoccupied?(px,py)
          spots << [px, py] # if self[px, py] == BLANK_MARK
        end
        spots.length == num_spots ? (return spots) : break
      end
    end
  end

  def out_of_range?(x,y)
    !((1..GRID_SIZE).include?(x) && (1..GRID_SIZE).include?(y))
  end

  def spot_unoccupied?(x,y)
    @ships.each do |ship|
      ship.coords.each do |loc|
        return false if x == loc[0] && y == loc[1]
      end
    end
    true
  end

  # def spots_occupied
  #   spots = []
  #   @ships.each do |ship|
  #     ship.coords.each do |loc|
  #       spots << loc
  #     end
  #   end
  #   spots.uniq.length
  # end

  def drop_bomb(x,y)
    return nil if out_of_range?(x,y) || !spot_empty?(x,y)
    self[x,y] = spot_unoccupied?(x,y) ? MISS_MARK : HIT_MARK
  end

  def spot_empty?(x,y)
    self[x,y] == BLANK_MARK
  end

  def display_ship_stats
    @ships.each do |ship|
      print "#{ship.name}: #{ship.sunk?(self) ? "*SUNK*" : "afloat"}     "
    end
    puts ""
  end

  def all_ships_sunk?
    @ships.each do |ship|
      return false if !ship.sunk?(self)
    end
    true
  end

  def []=(x,y,marker)
    @grid[y-1][x-1] = marker
  end

  def [](x,y)
    @grid[y-1][x-1]
  end

end

class Ship
  attr_accessor :name, :coords # [[1,2], [1,3]]

  def initialize(name, coords)
    @name = name
    @coords = coords
  end

  def sunk?(board)
    count = 0
    @coords.each do |position|
      count += 1 if board[position[0],position[1]] == Board::HIT_MARK
    end
    count == @coords.length ? true : false
  end
end

BattleshipGame.new