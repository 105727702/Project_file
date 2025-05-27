require 'ruby2d'

class Vector ## A simple 2D vector class for representing velocity and position
  attr_accessor :x, :y
  ## Initialize the vector with x and y coordinates
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def add(other_vector) ## Add another vector to this one
    @x += other_vector.x
    @y += other_vector.y
    self
  end

  def subtract(other_vector)  ## Subtract another vector from this one
    @x -= other_vector.x
    @y -= other_vector.y
    self
  end

  def multiply(scalar) ## Multiply this vector by a scalar
    @x *= scalar
    @y *= scalar
    self
  end

  def magnitude ## Calculate the magnitude (length) of the vector
    Math.sqrt(@x**2 + @y**2)
  end

  def normalize ## Normalize the vector to unit length
    mag = magnitude
    if mag.nonzero?
      @x /= mag
      @y /= mag
    end
    self
  end

  def limit(max) ## Limit the magnitude of the vector to a maximum value
    if magnitude > max
      normalize.multiply(max)
    end
    self
  end

  def dot_product(other_vector) ## Calculate the dot product with another vector
    @x * other_vector.x + @y * other_vector.y
  end
end

class Ball < Square
  attr_accessor :velocity, :speed

  def initialize
    super(x: 400, y: 200, size: 10, color: 'white')
    @velocity = Vector.new(5, 5)
    @speed = 5
  end

  def move
    self.x += @velocity.x
    self.y += @velocity.y
  end

  def bounce(surface_normal)
    # Reflect the velocity vector across the normal
    # v' = v - 2 * (v dot n) * n
    incident_direction = @velocity.multiply(1) # Create a copy
    dot_product = incident_direction.dot_product(surface_normal)
    reflection = surface_normal.multiply(2 * dot_product)
    @velocity.subtract(reflection)
    @velocity.multiply(1) # Ensure normalization doesn't affect anything
  end

  def reset_position ## Reset the ball's position to the center of the window with a random velocity
    self.x = 400
    self.y = 200
    @velocity = Vector.new(5, 5).multiply([1, -1].sample)
    @speed = 5
  end

  def accelerate(ax, ay) ## Accelerate the ball by a given amount in x and y directions
    @velocity.add(Vector.new(ax, ay))
  end

  def limit_speed(max_speed) ## Limit the speed of the ball to a maximum value
    @velocity.limit(max_speed)
  end
end
