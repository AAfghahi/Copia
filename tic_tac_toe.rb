class Board
    attr_reader :rows
  
    def self.blank_grid
      Array.new(3) { Array.new(3) }
    end
    #this creates a basic board 
    
    def initialize(rows = self.class.blank_grid)
      @rows = rows
    end
    #initializes a board state. So far this is O(1) time. 

    def [](pos)
      row, col = pos[0], pos[1]
      @rows[row][col]
    end
    #this creates a position function. 

    def []=(pos, mark)
      raise "mark already placed there!" unless empty?(pos)
  
      row, col = pos[0], pos[1]
      @rows[row][col] = mark
    end
  
    def cols
      cols = [[], [], []]
      @rows.each do |row|
        row.each_with_index do |mark, col_idx|
          cols[col_idx] << mark
        end
      end
  
      cols
    end
    #this just creates the columns, which are used to check the winner. 

    def diagonals
      down_diag = [[0, 0], [1, 1], [2, 2]]
      up_diag = [[0, 2], [1, 1], [2, 0]]
  
      [down_diag, up_diag].map do |diag|
        diag.map { |row, col| @rows[row][col] }
      end
    end
    #This goes through and checks through the diagonals, which determines the winner.  

    def dup
      duped_rows = rows.map(&:dup)
      self.class.new(duped_rows)
    end
  
    def empty?(pos)
      self[pos].nil?
    end
  
    def tied?
      return false if won?
  
      # no empty space?
      @rows.all? { |row| row.none? { |el| el.nil? }}
    end
    #checks every turn to make sure that there are valid moves left, and if no winner there is a cat's game. 

    def over?
      won? || tied?
    end
    #after every move to check if someone has won. 

    def winner
      (rows + cols + diagonals).each do |triple|
        return :x if triple == [:x, :x, :x]
        return :o if triple == [:o, :o, :o]
      end
  
      nil
    end
  
    def won?
      !winner.nil?
    end
end
  
=begin
This creates the board and checks for win conditions. Every single turn it checks for winning conditions and then puts in the x or o symbol depending on whose turn it is. I decided to make this a separate class
so that I could create a new board whenever I wanted, this gives me greater flexibility when playing the actual game. ALso it would allow me to play many games at once, if I wanted to, since each instance of a game
is just a duped board. 
=end
class TicTacToe
    attr_reader :board, :players, :turn

    def initialize(player1, player2)
        @board = Board.new
        @players = { :x => player1, :o => player2 }
        @turn = :x
    end

    #This assigns each player to either being x or o. If I wanted to, I could have the game run without there being human players. But I wanted there to be a Player class, first so that I could more easily give names and also because I thought that it would make more sense if the movements of each of the players was not in the gfame, but rather in a player class. This makes it easier to test if something is wrong, i.e if there is an error with the movement (purely in player) the board, or the game itself. 

    def run
        until self.board.over?
        play_turn
        end

        if self.board.won?
        winning_player = self.players[self.board.winner]
        puts "#{winning_player.name} won the game!"
        else
        puts "No one wins!"
        end
    end

    def show
        # not very pretty printing!
        self.board.rows.each { |row| p row }
    end
    #If i had more time I would have created a prettier game here. But I was rushing a bit. 

    private
    def place_mark(pos, mark)
        if self.board.empty?(pos)
        self.board[pos] = mark
        true
        else
        false
        end
    end

    def play_turn
        loop do
        current_player = self.players[self.turn]
        pos = current_player.move(self, self.turn)

        break if place_mark(pos, self.turn)
        end

        # swap next whose turn it will be next
        @turn = ((self.turn == :x) ? :o : :x)
    end
end


class HumanPlayer
    attr_reader :name

    def initialize(name)
        @name = name
    end

    def move(game, mark)
        game.show
        while true
        puts "#{@name}: please select your space "
        row, col = gets.chomp.split(",").map(&:to_i)
        if HumanPlayer.valid_coord?(row, col)
            return [row, col]
        else
            puts "Invalid coordinate!"
        end
        end
    end
    #This class is a bit superflous, but I didn't want the TicTacToe class to get too big, and I also thought that it would be nice to have named characters. This class is just the ability to do make a move. I also think that it would allow you to test things a bit easier, since spearating the moving from the run and show functions allows you to check for errors a bit easier. 
    private
    def self.valid_coord?(row, col)
        [row, col].all? { |coord| (0..2).include?(coord) }
    end
    #This method is private so that you can't call it outside of the class. Which means that you cannot do HumanPlayer.valid_coord? only the class can call it. 
end
  

  
  if __FILE__ == $PROGRAM_NAME
    puts "Play the dumb computer!"
    hp = HumanPlayer.new("Adam")
    hp2 = HumanPlayer.new('Matt')
  
    TicTacToe.new(hp, hp2).run
  end