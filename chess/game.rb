require_relative './board.rb'
require_relative './pieces.rb'
require_relative './steppers.rb'
require_relative './sliders.rb'

module Chess
  class Game
    def initialize(player1, player2)
      @player1, @player2 = player1, player2
      @board = Board.new
      @player_colors = { :white => @player1, :black => @player2 }
    end

    def setup_normal_game
      @board[[0, 0]] = Chess::Rook.new(:white, [0, 0], @board)
      @board[[1, 0]] = Chess::Knight.new(:white, [1, 0], @board)
      @board[[2, 0]] = Chess::Bishop.new(:white, [2, 0], @board)
      @board[[3, 0]] = Chess::Queen.new(:white, [3, 0], @board)
      @board[[4, 0]] = Chess::King.new(:white, [4, 0], @board)
      @board[[5, 0]] = Chess::Bishop.new(:white, [5, 0], @board)
      @board[[6, 0]] = Chess::Knight.new(:white, [6, 0], @board)
      @board[[7, 0]] = Chess::Rook.new(:white, [7, 0], @board)

      @board[[0, 7]] = Chess::Rook.new(:black, [0, 7], @board)
      @board[[1, 7]] = Chess::Knight.new(:black, [1, 7], @board)
      @board[[2, 7]] = Chess::Bishop.new(:black, [2, 7], @board)
      @board[[3, 7]] = Chess::Queen.new(:black, [3, 7], @board)
      @board[[4, 7]] = Chess::King.new(:black, [4, 7], @board)
      @board[[5, 7]] = Chess::Bishop.new(:black, [5, 7], @board)
      @board[[6, 7]] = Chess::Knight.new(:black, [6, 7], @board)
      @board[[7, 7]] = Chess::Rook.new(:black, [7, 7], @board)

      8.times do |column|
        @board[[column, 1]] = Chess::Pawn.new(:white, [column, 1], @board)
        @board[[column, 6]] = Chess::Pawn.new(:black, [column, 6], @board)
      end
    end

    def full_game
      setup_normal_game
      until @board.checkmate?
        @board.show
        begin
          start_sq, end_sq = @player_colors[@board.turn_color].play_turn
          @board.move(start_sq, end_sq)
        rescue ArgumentError => error
          puts error
        end
      end
    end
  end
end

class Array
  def add_elements!(other_array)
    self.map!.with_index do |_, index|
      self[index] + other_array[index]
    end
  end

  def add_elements(other_array)
    self.dup.add_elements!(other_array)
  end
end


x = Chess::Game.new("fred","joe")
x.full_game

# x = Chess::Board.new
# test_king = Chess::King.new(:white, [0, 0], x)
# x[[0, 0]] = test_king
# test_rook = Chess::Rook.new(:black, [7, 1], x)
# x[[7, 1]] = test_rook
# test_rook1 = Chess::Rook.new(:black, [6, 1], x)
# x[[6, 1]] = test_rook1
#
# test_pawn2 = Chess::Pawn.new(:white, [6, 6], x)
# x[[6, 6]] = test_pawn2
# # x.show
# # x.move([5, 7],[5, 5])
# # p test_rook.valid_moves
# # x.show
# # x.king_square(:black)
# # p x.in_check?(:black)
# x.show
# p x.checkmate?
# x.turn_color = :black
# x.move([6, 1], [6, 0])
# x.show
# p x.checkmate?
# puts "W BOARD"
# w.show
# puts "X BOARD"
# x.show
