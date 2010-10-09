module Tipping
  MAX_INT = 1000000
  MIN_INT = -1000000

  class AlphaBeta

    def self.move(position, depth, alpha = MIN_INT, beta = MAX_INT)
      return position.move if depth == 0

      best_move  = MIN_INT
      local_alpha = alpha

      position.next_moves.each do |move|
        best_move = [
          best_move,
          -AlphaBeta.move(move.position, depth - 1, -beta, -local_alpha)
        ].max

        break if best_move >= beta
        local_alpha = best_move if best_move > local_alpha
      end

      best_move
    end

  end

end

