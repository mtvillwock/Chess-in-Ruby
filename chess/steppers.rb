module Chess

  class Stepper < Piece
    def valid_moves
      @moves.map { |direction| @square.add_elements(direction) }
        .select { |move| move_valid?(move) }
    end
  end

  class King < Stepper
    def initialize(color, square, board)
      super(color, square, board)
      @moves = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]
    end

    def to_s
      @color == :white ? "\u265A".encode("UTF-8") : "\u2654".encode("UTF-8")
    end
  end

  class Knight < Stepper
    def initialize(color, square, board)
      super(color, square, board)
      @moves = [
        [1, 2], [-1, 2], [1, -2], [-1, -2],
        [2, 1], [-2, 1], [2, -1], [-2, -1]
      ]
    end

    def to_s
      @color == :white ? "\u2658".encode("UTF-8") : "\u265E".encode("UTF-8")
    end
  end
end