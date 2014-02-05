require_relative './board.rb'
require_relative './pieces.rb'
require_relative './steppers.rb'
require_relative './sliders.rb'
require_relative './players.rb'

module Chess
  class Game
    def initialize(player1, player2)
      @player1, @player2 = player1, player2
      @board = Board.new
      @player_colors = { :white => @player1, :black => @player2 }
    end

    def setup_normal_game
      paired_pieces = [Chess::Rook, Chess::Knight, Chess::Bishop]
      paired_pieces.each_with_index do |piece, col|
        @board[[col, 0]] = piece.new(:white, [col, 0], @board)
        @board[[col, 7]] = piece.new(:black, [col, 7], @board)
        @board[[7 - col, 0]] = piece.new(:white, [7 - col, 0], @board)
        @board[[7 - col, 7]] = piece.new(:black, [7 - col, 7], @board)
      end

      unpaired_pieces = [Chess::Queen, Chess::King]
      unpaired_pieces.each_with_index do |piece, col|
        @board[[3 + col, 0]] = piece.new(:white, [3 + col, 0], @board)
        @board[[3 + col, 7]] = piece.new(:black, [3 + col, 7], @board)
      end

      8.times do |column|
        @board[[column, 1]] = Chess::Pawn.new(:white, [column, 1], @board)
        @board[[column, 6]] = Chess::Pawn.new(:black, [column, 6], @board)
      end
    end

    def full_game
      setup_normal_game
      until @board.checkmate?
        @board.show
        puts "check!" if @board.in_check?
        begin
          player_move = @player_colors[@board.turn_color].play_turn
          if player_move.all? { |coord| coord == "O" }
            player_move.length == 2 ? @board.king_castle : @board.queen_castle
          else
            start_sq, end_sq = player_move
            @board.move(start_sq, end_sq)
          end

          self.search_do_promotion
        rescue ArgumentError => error
          puts error
        end
      end
      @board.show
      winner = @board.turn_color == :white ? :black : :white
      puts "#{winner} wins!"
    end

    def search_do_promotion
      if piece = @board.needs_promotion
        promotion_type = @player_colors[piece.color].choose_promotion
        @board.handle_promotion(piece, promotion_type)
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

fred = Chess::HumanPlayer.new
joe = Chess::HumanPlayer.new

x = Chess::Game.new(fred, joe)
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
