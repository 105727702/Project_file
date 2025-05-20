class Ball < Square
  attr_accessor :x_move, :y_move, :move_speed

  def initialize
    super(x: 400, y: 200, size: 10, color: 'white') 
    @x_move = 5
    @y_move = 5
    @move_speed = 0
  end

  def move
    self.x += @x_move
    self.y += @y_move
  end

  def bounce_y
    @y_move *= -1
  end

  def bounce_x
    @x_move *= -1
  end

  def reset_position
    self.x = 400
    self.y = 200
    bounce_x
    @move_speed = 0
  end
end