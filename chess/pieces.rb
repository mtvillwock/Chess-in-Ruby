require 'colorize'

module Chess
  class Piece
    attr_accessor :moves, :color, :square, :board

    def initialize(color, square, board)
      @color, @square, @board = color, square, board
    end

    def on_board?(location)
      location.all? { |coord| coord.between?(0, 7) }
    end

    def move_valid?(square)
      on_board?(square) && !@board.has_own_piece?(square, self.color)
    end

    def recreate(new_board)
      self.dup.tap do |new_piece|
        new_piece.board = new_board
        new_piece.square = self.square.dup
      end
    end
  end


  class Pawn < Piece
    def initialize(color, square, board)
      super(color, square, board)

      direction = ( self.color == :white ? 1 : -1 )
      @moves = [[0, direction]]
      @captures = [[1, direction], [-1, direction]]
    end

    def start_row?
      start_row = (@color == :white ? 1 : 6)
      @square[1] == start_row
    end

    def valid_moves
      valid_non_attacks  + valid_attacks
    end

    def valid_non_attacks
      next_space = @square.add_elements(@moves[0])
      num_moves = (self.start_row? ? 2 : 1)
      [].tap do |non_attacks|
        num_moves.times do
          break unless @board[next_space].nil?
          non_attacks << next_space.dup
          next_space.add_elements!(@moves[0])
        end
      end
    end

    def valid_attacks
      [].tap do |attacks|
        @captures.each do |direction|
          next_space = @square.add_elements(direction)
          if !@board[next_space].nil? && move_valid?(next_space)
            attacks << next_space
          end
        end
      end
    end

    def to_s
      ("\u265F".encode("UTF-8")+ " ")
    end
  end
end
