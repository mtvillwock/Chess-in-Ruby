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

    attr_accessor :en_passantable

    def initialize(color, square, board)
      super(color, square, board)

      @up_or_down = ( self.color == :white ? 1 : -1 )
      @moves = [[0, @up_or_down]]
      @captures = [[1, @up_or_down], [-1, @up_or_down]]
      @en_passants = [[-1, 0], [1, 0]]
      @en_passantable = false
    end

    def valid_moves
      valid_non_attacks + valid_attacks + en_passant_moves
    end

    def en_passant_moves
      [].tap do |en_passants|
        @en_passants.each do |direction|
          next_space = @square.add_elements(direction)
          if en_passant?(next_space)
            en_passants << next_space.add_elements([0, @up_or_down])
          end
        end
      end
    end

    def valid_non_attacks
      next_space = @square.add_elements(@moves[0])
      num_moves = (start_row? ? 2 : 1)
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

    private

    def start_row?
      start_row = (@color == :white ? 1 : 6)
      @square[1] == start_row
    end

    def en_passant?(next_space)
      @board[next_space].is_a?(Chess::Pawn) &&
        @board[next_space].en_passantable   &&
        move_valid?(next_space)
    end

  end
end
