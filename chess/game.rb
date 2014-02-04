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
test_pawn = Chess::Pawn.new(:black, [3,6], x)
x[[3,6]] = test_pawn
test_knight = Chess::Knight.new(:black, [3,3], x)
x[[3,3]] = test_knight
test_pawn2 = Chess::Pawn.new(:white, [2,2], x)
x[[2,2]] = test_pawn
x.show
p test_pawn2.valid_moves
p test_pawn.valid_moves

