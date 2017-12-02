# Console Based Snake Game
# (c) Omar Baqueiro
# Licensed in the WTFPL license ( http://www.wtfpl.net/ )

require 'io/console'

class Snake
  def initialize(board_size, lives)
    # create board
    @board = Array.new(board_size) {Array.new(board_size)}
    @lives = lives
    reset_snake
    @score = 0
end

  def reset_snake
    @snake = [{r: rand(@board.size), c: rand(@board.size)}]
    @direction = [:up, :right, :left, :down].sample(1)[0]
    @fruit = {r: rand(@board.size), c: rand(@board.size)}
  end

  def draw_board
    puts("Lives: #{@lives}")
    puts("Score: #{@score + @snake.size-1 }")
    @board.each_with_index do |row,row_index|
      row.each_with_index do |col, col_index|
        if @fruit[:r] == row_index && @fruit[:c] == col_index
           print('O')
        elsif  @snake.find {|t| t[:r] == row_index && t[:c] == col_index}
          print('█')
        else print('░')
        end
      end
      puts("")
    end
  end

  def update_board
    system('clear')
    head = @snake.last.dup
    case @direction
    when :up
      head[:r] -= 1
    when :down
      head[:r] += 1
    when :right
      head[:c] += 1
    when :left
      head[:c] -= 1
    end

    if @snake.find {|t| t[:r] == head[:r] && t[:c] == head[:c]}
      lose_live
      return
    end
    @snake.push(head)

    if(head[:c] < 0 || head[:c] >= @board.size ||
       head[:r] < 0 || head[:r] >= @board.size )
       lose_live
       return
    end



    if (head[:c] == @fruit[:c] && head[:r] == @fruit[:r])
      @score += 1
      @fruit = {r: rand(@board.size), c: rand(@board.size)}
    else
      @snake.shift
    end
  end

  def get_next_move
     move = case  getkey
      when 'w'
        :up
      when 's'
        :down
      when 'a'
        :left
      when 'd'
        :right
      when 'q'
       :quit
      else
         @direction
      end
    exit if move == :quit
    return if @direction == :up && move == :down ||  @direction == :down && move == :up
    return if @direction == :left && move == :right ||  @direction == :right && move == :left
    @direction = move
  end

  def lose_live
    puts("You lost a live!")
    reset_snake
    @lives-=1
  end

  def run
    while (@lives > 0)
      update_board
      draw_board
      move = get_next_move
      sleep(0.5)
    end
    puts("You lost all your lives... Game Over")
  end

  def getkey
    system("stty raw -echo")
    char = STDIN.read_nonblock(1) rescue nil
    system("stty -raw echo")
      return char
  end
end

Snake.new(20,3).run
