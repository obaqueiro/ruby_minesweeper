# Ruby Sample MineSweeper Console Game
# (c) Omar Baqueiro
# Licensed in the WTFPL license ( http://www.wtfpl.net/ )


class MineSweeper
    MINE_CHAR = '*'
    # Initializes board with provided parameters, positioning mines
    # @board_size Number of columns and rows in the board
    # @difficulty 1 to 100:  % of cells in the board that are mines
    def initialize(board_size,difficulty)
      @board = Array.new(board_size) { Array.new(board_size) { ' ' } }
      @board_revealed = Array.new(board_size) { Array.new(board_size) }
      @dead = false
      @difficulty = difficulty
      place_mines
    end

    # Main run method for the game.
    def run
      while (!@dead)
        draw_board
        move = get_next_move
        process_move(move)
      end
    end

    private

    def place_mines
      board_size = @board.size
      total_mines = ((board_size ** 2) * @difficulty / 100).round
      while (total_mines > 0)
        col = rand(board_size)
        row = rand(board_size)
        if (@board[row][col] != MINE_CHAR )
          @board[row][col] = MINE_CHAR
          total_mines -= 1
        end
      end
    end

    # This prints the board...
    def draw_board
      puts('_' * @board.size)
      @board.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index |
          print( @board_revealed[row_index][col_index] ? col : '#'  )
        end
        puts('')
      end
      puts('_' * @board.size)
    end

    def get_next_move
      valid_move = false
      while (!valid_move)
        puts("Say your next move (e.g.  10,5 for row 10, col 5)")
        next_move = gets.chomp.split(',')
        if next_move.size != 2
           puts("Invalid Move... try again")
        else
          next_move = next_move.map {|i| i.to_i}
          valid_move = true
        end
      end
      next_move
    end

    def process_move(move)
      row = move[0]
      col = move[1]
      @board_revealed[row][col] = 1
      if @board[move[0]][move[1]] == MINE_CHAR
        draw_board
        lose_game
        return
      end
      process_adjacent_mines(row,col,2)

      # check if player won the Game (if all the "covered" cells are mines)
      if (check_win)
        win_game
      end

    end

    def process_adjacent_mines(row,col,count)
      return if count == 0
      board_size = @board.size
      # We do nothing if the current cell is a mine... stop condition
      return if @board[row][col] == MINE_CHAR
      return if row >= board_size  || col >= board_size
      return if row < 0 || col < 0

      adj = [[row-1,col], [row+1,col],[row,col+1],[row,col-1],
        [row-1, col-1], [row-1, col+1], [row+1, col+1], [row+1, col-1]]

      adj = adj.reject do |t|
         t[0] >= board_size || t[1] >= board_size || t[0] < 0 || t[1] < 0 ||
         @board_revealed[t[0]][t[1]]
       end
      sum_mines =
        adj.inject(0) {|sum,t| sum + (@board[t[0]][t[1]] == MINE_CHAR ? 1 : 0)}
      @board[row][col] = sum_mines > 0 ? "#{sum_mines}" : ' '
      @board_revealed[row][col] = 1

      adj.each { |t| process_adjacent_mines(t[0],t[1],count-1)}
    end

    def check_win
      @board.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index |
           if @board_revealed[row_index][col_index].nil? &&
              @board[row_index][col_index] != MINE_CHAR
              return false
          end
        end
      end
    end

    def win_game
      puts("PERFECT!! YO WON THE GAME. Congrats§")
      puts("Game Over")
      @dead=true
    end

    def lose_game
      puts("I am sorry.. YOU LOSE")
      puts('Game over')
      @dead=true
    end

end

MineSweeper.new(3 , 30).run if __FILE__ == $PROGRAM_NAME
