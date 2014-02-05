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
test_king = Chess::King.new(:black, [3,7], x)
x[[3,7]] = test_king
test_knight = Chess::Knight.new(:white, [5,5], x)
x[[5,5]] = test_knight
test_pawn2 = Chess::Pawn.new(:white, [2,2], x)
x[[2,2]] = test_pawn2
# x.show
# x.move([5, 7],[5, 5])
# p test_knight.valid_moves
# x.show
# x.king_square(:black)
# p x.in_check?(:black)
x.show
w = x.dup
x.move([5,5], [6,7])
puts "W BOARD"
w.show
puts "X BOARD"
x.show
