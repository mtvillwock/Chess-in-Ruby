

module Chess
  class Board
    attr_accessor :board, :turn_color

    def initialize
      @board = Array.new(8) { Array.new(8) { nil } }
      @turn_color = :white
    end

    def show
      @board.map do |row|
        p row.map { |square| square.nil? ? "_" : square.to_s }
      end
    end

    def dup
      Board.new.tap do |new_board|
        each_piece_with_square do |piece, square|
          new_board[square] = (piece.nil? ? nil : piece.recreate(new_board))
        end
        new_board.turn_color = self.turn_color
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

    def has_own_piece?(square, color = self.turn_color)
      (piece = self[square]) && (piece.color == color)
    end

    def king_square
      self.each_piece_with_square do |piece, square|
        return square if piece.is_a?(King) && piece.color == self.turn_color
      end
    end


    def each_piece_with_square(&blk)
      if blk
        (0...8).each do |row|
          (0...8).each do |col|
              blk.call([self[[row,col]], [row,col]])
          end
        end
      else
        Enumerator.new do |yielder|
          (0...8).each do |row|
            (0...8).each do |col|
                yielder << [self[[row,col]], [row,col]]
            end
          end
        end
      end
    end

    def in_check?
      king_location = king_square
      self.each_piece_with_square do |piece, square|
        next if piece.nil? || piece.color == self.turn_color
        return true if piece.valid_moves.include?(king_location)
      end
      false
    end

    #only works on otherwise valid move
    def leaves_in_check?(start_square, end_square)
      test_board = self.dup
      color = self[start_square].color
      test_board.execute_move(start_square, end_square)
      test_board.in_check?
    end

    def execute_move(start_square, end_square)
      piece = self[start_square]
      self[start_square] = nil
      self[end_square] = piece
      piece.square = end_square
    end

    def move(start_square, end_square)
      piece = self[start_square]
      if piece.nil? || piece.color != self.turn_color
       raise ArgumentError.new "There is no piece at #{start_square}"
      elsif !piece.valid_moves.include?(end_square)
        raise ArgumentError.new "This is not a valid move"
      elsif leaves_in_check?(start_square, end_square)
        raise ArgumentError.new "This would leave you in check"
      else
        execute_move(start_square, end_square)
        self.turn_color = (self.turn_color == :white? ? :black : :white)
      end
    end

    def checkmate?
      return false unless self.in_check?
      each_piece_with_square.all? do |piece, square|
        piece.nil? || piece.color != turn_color ||
        piece.valid_moves.all? do |move|
          leaves_in_check?(square, move)
        end
      end
    end
  end
end