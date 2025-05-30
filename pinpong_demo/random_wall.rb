require 'ruby2d'

class Wall < Rectangle ## Wall class for the Pong game, representing a wall that moves vertically
  attr_accessor :y_speed
  WALL_WIDTH = 10  ## Define wall dimensions as constants
  WALL_HEIGHT = 100

  def initialize(x, y)
    super(x: x, y: y, width: WALL_WIDTH, height: WALL_HEIGHT, color: 'gray')## It inherits from Rectangle and has methods to move, check valid position, and define wall dimensions
    @y_speed = [2, 3].sample
  end

  def move
    self.y += @y_speed
    if self.y <= 0 || self.y + self.height >= Window.height
      @y_speed *= -1
    end
  end

  def self.valid_position(new_x, new_y, existing_walls, min_distance)  ## Check if the new wall position is valid
    existing_walls.each do |wall|
      if (new_x < wall.x + wall.width + min_distance && ## Check if the new wall overlaps with existing walls
          new_x + WALL_WIDTH + min_distance > wall.x &&  
          new_y < wall.y + wall.height + min_distance &&
          new_y + WALL_HEIGHT + min_distance > wall.y) 
        return false ## Overlapping or too close
      end
    end
    return true ## Valid position
  end
end







