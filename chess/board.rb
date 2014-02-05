

module Chess
  class Board
    attr_accessor :board, :turn_color

    def initialize
      @board = Array.new(8) { Array.new(8) { nil } }
      @turn_color = :white
    end

    def show
      print_board = @board.map.with_index do |row, row_ind|
        row.map.with_index do |square, col_ind|
          piece_color = (square.nil? || square.color == :white ? :white : :red)
          sq_color = ((row_ind + col_ind).even? ? :light_blue : :black)
          (square.nil? ? "  " : square.to_s)
          .colorize(:background => sq_color, :color => piece_color)
        end
        .join
      end

      puts print_board
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
        if piece.valid_moves.include?(king_location)
          return true
        end
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
        self.turn_color = (self.turn_color == :white ? :black : :white)
      end
    end

    def checkmate?
      return false unless self.in_check?
      each_piece_with_square.all? do |piece, square|
        piece.nil? || piece.color != turn_color ||
        piece.valid_moves.all? do |move|
          p [square, move] unless leaves_in_check?(square, move)
          leaves_in_check?(square, move)
        end
      end
    end

    def needs_promotion
      (0..7).each do |col|
        return self[[col, 0]] if self[[col, 0]].is_a?(Chess::Pawn)
        return self[[col, 7]] if self[[col, 7]].is_a?(Chess::Pawn)
      end
      nil
    end

    def handle_promotion(piece, promotion_type)
      new_piece = promotion_type.new(piece.color, piece.square, self)
      self[piece.square] = new_piece
    end

    def king_castle?
      row = (self.turn_color == :white ? 0 : 7)
      !self.in_check? &&
        self[king_square].unmoved? &&
        self[[7, row]].is_a?(Chess::Rook) &&
        self[[7, row]].unmoved? &&
        self[[5, row]].nil? &&
        self[[6, row]].nil? &&
        !leaves_in_check?([4, row], [5, row]) &&
        !leaves_in_check?([4, row], [6, row])
    end

    def king_castle
      unless self.king_castle?
        raise ArgumentError.new "You can't castle this way"
      end
      row = (self.turn_color == :white ? 0 : 7)
      execute_move([4, row], [6, row])
      execute_move([7, row], [5, row])
      self.turn_color = (self.turn_color == :white ? :black : :white)
    end

    def queen_castle?
      row = (self.turn_color == :white ? 0 : 7)
      !self.in_check? &&
        self[king_square].unmoved? &&
        self[[0, row]].is_a?(Chess::Rook) &&
        self[[0, row]].unmoved? &&
        self[[1, row]].nil? &&
        self[[2, row]].nil? &&
        self[[3, row]].nil? &&
        !leaves_in_check?([4, row], [3, row]) &&
        !leaves_in_check?([4, row], [2, row])
    end

    def queen_castle
      unless self.queen_castle?
        raise ArgumentError.new "You can't castle this way"
      end
      row = (self.turn_color == :white ? 0 : 7)
      execute_move([4, row], [2, row])
      execute_move([0, row], [3, row])
      self.turn_color = (self.turn_color == :white ? :black : :white)
    end


  end
end