class Player
  attr_reader :x, :y

  START_Y = 550
  MOVE_DISTANCE = 10
  FINISH_Y = 50

  def initialize
    @x = 300
    @y = START_Y
    # @image = Gosu::Image.new("turtle.png")
  end

  def move_up
    @y -= MOVE_DISTANCE
  end

  def move_down
    @y += MOVE_DISTANCE
  end

  def reset_position
    @y = START_Y
  end

  def reached_finish?
    @y < FINISH_Y
  end

  def draw
    Gosu.draw_rect(@x - 10, @y - 10, 20, 20, Gosu::Color::BLACK)
  end
end
