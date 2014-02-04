SIZE = 8

module Chess
  class Piece
    attr_accessor :moves, :color

    def initialize(color, square, board)
      @color, @square, @board = color, square, board
    end

    def on_board?(location)
      location.all? { |coord| coord.between?(0, 7) }
    end

    def move_valid?(square)
      on_board?(square) && !@board.has_own_piece?(square, self.color)
    end
  end
end
