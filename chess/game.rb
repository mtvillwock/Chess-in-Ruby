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
        begin
          start_sq, end_sq = @player_colors[@board.turn_color].play_turn
          @board.move(start_sq, end_sq)
        rescue ArgumentError => error
          puts error
        end
      end
      @board.show
      winner = @board.turn_color == :white ? :black : :white
      puts "#{winner} wins!"
    end
  end

  class HumanPlayer
    X_VAL = ("a".."h").to_a
    Y_VAL = ("1".."8").to_a

    def play_turn
      begin
        puts ("Please enter the beginning and end coordinates of the piece" +
           " you want to move")

        move_coords = gets.chomp.split("-").map do |coord|
          [X_VAL.index(coord[0]), Y_VAL.index(coord[1])]
        end
        process_input(move_coords.flatten)
        move_coords
      rescue ArgumentError => error
        puts error
        retry
      end
    end

    def process_input(user_input)
      if user_input.nil? || user_input.include?(nil)
        raise ArgumentError.new "Invalid input"
      end
    end

    def choose_promotion
      promo_pieces = {
        "b" => Chess::Bishop,
        "n" => Chess::Knight,
        "r" => Chess::Rook,
        "q" => Chess::Queen }
      begin
        puts "What would you like to promote your pawn to?"
        puts "Bishop (b), Knight (n), Rook (r), or Queen (q)"
        promo_pieces[gets.chomp.downcase].tap do |chosen_piece|
          process_input(chosen_piece)
        end
      rescue ArgumentError => error
        puts error
        retry
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
