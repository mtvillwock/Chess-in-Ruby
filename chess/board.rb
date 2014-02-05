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

    def dup
      Board.new.tap do |new_board|
        each_piece_with_square do |piece, square|
          new_board[square] = (piece.nil? ? nil : piece.recreate(new_board))
        end
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

    def king_square(check_color)
      self.each_piece_with_square do |piece, square|
        return square if piece.is_a?(King) && piece.color == check_color
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

    def in_check?(color)
      king_location = king_square(color)
      self.each_piece_with_square do |piece, square|
        next if piece.nil? || piece.color == color
        return true if piece.valid_moves.include?(king_location)
      end
      false
    end

    # def leaves_in_check?(start_square, end_square)
    #   test_board = self.dup
    #
    # end

    def move(start_square, end_square)
      piece = self[start_square]
      if piece.nil?
       raise ArgumentError.new "There is no piece at #{start_square}"
      elsif !piece.valid_moves.include?(end_square)
        raise ArgumentError.new "This is not a valid move"
      elsif

      else
        self[start_square] = nil
        self[end_square] = piece
        piece.square = end_square
      end
    end

  end
end