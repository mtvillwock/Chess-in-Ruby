module Chess
  class King < Stepper
    def initialize(color, square, board)
      super(color, square, board)
      @moves = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]
    end
  end
end