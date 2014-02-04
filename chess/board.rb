module Chess
  class Board
    attr_accessor :board

    def initialize
      @board = Array.new(8) { Array.new(8) { nil } }
    end

    def show
      @board.map do |row|
        p row.map { |square| square.nil? ? "_" : square.to_s }
      end
    end

    def [](square)
      col, row = square
      @board[7 - row][col]
    end

    def []=(square, piece)
      col, row = square
      @board[7 - row][col] = piece
    end

    def has_own_piece?(square, my_color)
      (piece = self[square]) && (piece.color == my_color)
    end

  end
end