module Chess
  class HumanPlayer
    X_VAL = ("a".."h").to_a
    Y_VAL = ("1".."8").to_a

    def play_turn
      begin
        puts ("Please enter the beginning and end coordinates of the piece" +
           " you want to move")
        get_move
      rescue ArgumentError => error
        puts error
        retry
      end
    end

    def get_move
      move_coords = gets.chomp.split("-")
      unless move_coords.all? { |word| word == 'O' }
        move_coords.map! do |coord|
          [X_VAL.index(coord[0]), Y_VAL.index(coord[1])]
        end
        process_input(move_coords.flatten)
      end
      move_coords
    end

    def process_input(user_input)
      if user_input.nil? ||
        (user_input.is_a?(Array) && user_input.include?(nil))
        raise ArgumentError.new "Invalid input"
      end
    end

    def choose_promotion
      promo_pieces = {
        "b" => Chess::Bishop,
        "n" => Chess::Knight,
        "r" => Chess::Rook,
        "q" => Chess::Queen }
      begin
        puts "What would you like to promote your pawn to?"
        puts "Bishop (b), Knight (n), Rook (r), or Queen (q)"
        promo_pieces[gets.chomp.downcase].tap do |chosen_piece|
          process_input(chosen_piece)
        end
      rescue ArgumentError => error
        puts error
        retry
      end
    end
  end
end