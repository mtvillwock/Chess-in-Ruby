module Chess
  class Knight < Stepper
    
    def initialize(color, square, board)
      super(color, square, board)
      @moves = [
        [1, 2], [-1, 2], [1, -2], [-1, -2],
        [2, 1], [-2, 1], [2, -1], [-2, -1]
      ]
    end
  end
end