module Chess
  class Board
    attr_accessor :board

    def initialize
      @board = Array.new(8) { Array.new(8) { nil } }
    end

    def show
      @board.each { |row| p row }
    end

    def [](square)
      row, col = square
      @board[row][col]
    end

    def []=(square, piece)
      row, col = square
      @board[row][col] = piece
    end

    def is_empty?(square)
      self[square].nil?
    end

    def has_own_piece?(square, color)
      piece = self[square] && piece.color == color
    end

  end
end

x = Chess::Board.new
x.show