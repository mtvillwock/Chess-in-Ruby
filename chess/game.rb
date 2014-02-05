require_relative './board.rb'
require_relative './pieces.rb'
require_relative './steppers.rb'
require_relative './sliders.rb'

module Chess
  class Game
    def initialize(player1, player2)
      @player1, @player2 = player1, player2
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


x = Chess::Board.new
test_king = Chess::King.new(:white, [0, 0], x)
x[[0, 0]] = test_king
test_rook = Chess::Rook.new(:black, [7, 1], x)
x[[7, 1]] = test_rook
test_rook1 = Chess::Rook.new(:black, [6, 1], x)
x[[6, 1]] = test_rook1

test_pawn2 = Chess::Pawn.new(:white, [6, 6], x)
x[[6, 6]] = test_pawn2
# x.show
# x.move([5, 7],[5, 5])
# p test_rook.valid_moves
# x.show
# x.king_square(:black)
# p x.in_check?(:black)
x.show
p x.checkmate?
x.turn_color = :black
x.move([6, 1], [6, 0])
x.show
p x.checkmate?
# puts "W BOARD"
# w.show
# puts "X BOARD"
# x.show
