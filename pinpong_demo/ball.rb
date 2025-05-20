require 'ruby2d'

class Vector
  attr_accessor :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def add(other_vector)
    @x += other_vector.x
    @y += other_vector.y
    self
  end

  def subtract(other_vector)
    @x -= other_vector.x
    @y -= other_vector.y
    self
  end

  def multiply(scalar)
    @x *= scalar
    @y *= scalar
    self
  end

  def magnitude
    Math.sqrt(@x**2 + @y**2)
  end

  def normalize
    mag = magnitude
    if mag.nonzero?
      @x /= mag
      @y /= mag
    end
    self
  end

  def limit(max)
    if magnitude > max
      normalize.multiply(max)
    end
    self
  end

  def dot_product(other_vector)
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

  def reset_position
    self.x = 400
    self.y = 200
    @velocity = Vector.new(5, 5).multiply([1, -1].sample)
    @speed = 5
  end

  def accelerate(ax, ay)
    @velocity.add(Vector.new(ax, ay))
  end

  def limit_speed(max_speed)
    @velocity.limit(max_speed)
  end
end
