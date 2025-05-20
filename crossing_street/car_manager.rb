class Car
  attr_accessor :x, :y, :color

  def initialize
    @x = 600
    @y = rand(20..450)
    @color = Gosu::Color.argb(0xff000000 + rand(0xffffff))
  end

  def move(speed)
    @x -= speed
  end

  def draw
    Gosu.draw_rect(@x, @y, 40, 20, @color)
  end
end

class CarManager
  attr_reader :cars

  def initialize
    @cars = []
    @speed = 3
  end

  def generate_cars
    @cars << Car.new if rand(18) == 0
  end

  def move_cars
    @cars.each { |car| car.move(@speed) }
  end

  def increase_speed
    @speed += 1
  end

  def draw
    @cars.each(&:draw)
  end
end
