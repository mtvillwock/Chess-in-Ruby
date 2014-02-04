module Chess
  class Queen < Slider
    def intitialize(color, square, board)
      super(color, square, board)
      @move_directions =  CARDINAL + DIAGONAL
    end
  end

  class Rook < Slider
    def intitialize(color, square, board)
      super(color, square, board)
      @move_directions =  CARDINAL
    end
  end

  class Bishop < Slider
    def intitialize(color, square, board)
      super(color, square, board)
      @move_directions =  DIAGONAL
    end
  end
end