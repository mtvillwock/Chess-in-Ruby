module Chess
  class Slider < Piece
    CARDINAL = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    DIAGONAL = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

    def valid_moves
      [].tap do |all_valids|
        @move_directions.each do |direction|
          next_move = @square.add_elements(direction)
          until !move_valid?(next_move)
            all_valids << next_move.dup
            break if !@board[next_move].nil?
            next_move.add_elements!(direction)
          end
        end
      end
    end
  end

  class Queen < Slider
    def initialize(color, square, board)
      super
      @move_directions =  CARDINAL + DIAGONAL
    end

    def to_s
      ("\u265B".encode("UTF-8") + " ")
    end
  end

  class Rook < Slider

    def initialize(color, square, board)
      super
      @move_directions =  CARDINAL
      @unmoved = true
    end

    def square=(pos)
      @unmoved = false
      @square = pos
    end

    def unmoved?
      @unmoved
    end

    def to_s
      ("\u265C".encode("UTF-8") + " ")
    end
  end

  class Bishop < Slider
    def initialize(color, square, board)
      super(color, square, board)
      @move_directions =  DIAGONAL
    end

    def to_s
      ("\u265D".encode("UTF-8") + " ")
    end
  end
end

# for pawns
#@color == :white ? "\u2659".encode("UTF-8") : "\u265F".encode("UTF-8")