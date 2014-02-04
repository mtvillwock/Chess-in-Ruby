SIZE = 8

module Chess
  class Piece
    attr_accessor :moves

    def initialize(color, square, board)
      @color, @square, @board = color, square, board
    end

    def on_board?(location)
      location.all? { |coord| coord.between?(0, 7) }
    end
  end

  class Slider < Piece
    CARDINAL = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    DIAGONAL = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end

  class Stepper < Piece
    def valid_moves
      row, col = @square
      @moves.map { |row_plus, col_plus| [row_plus + row, col_plus + col] }
        .select { |move| move_valid?(move) }
    end

    def move_valid?(square)
      on_board?(square) && !@board.has_own_piece?(square, self.color)
    end

  end
end
