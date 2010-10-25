module Emergency

  module Positioning

    def update_position(opts = {})
      position.x = opts[:x]
      position.y = opts[:y]
    end

    def position
      @position ||= Position.new
    end

    def position=(pos)
      @position = pos
    end

    def x
      position.x
    end

    def y
      position.y
    end

    def to_coord
      position.to_coord
    end

    def nearest(positions)
      positions.sort { |a, b| position.distance_to(a) <=> position.distance_to(b) }.first
    end

    def distance_to(pos)
      position.distance_to pos
    end

  end

  class Position

    def self.center(pos_1, pos_2)
      x = ((pos_1.x - pos_2.x) / 2).to_i + pos_2.x
      y = ((pos_1.y - pos_2.y) / 2).to_i + pos_2.y
      Position.new(x, y)
    end
    
    def self.distance(point_1, point_2)
      (point_1[0] - point_2[0]).abs + (point_1[1] - point_1[1]).abs
    end

    attr_accessor :x, :y
    def initialize(x = nil, y = nil)
      @x = x; @y = y
    end

    def distance_to(pos)
      (self.x.to_i - pos.x.to_i).abs + (self.y.to_i - pos.y.to_i).abs
    end
    
    def to_coord
      [x,y]
    end
  end

end