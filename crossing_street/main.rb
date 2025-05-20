require_relative 'player'
require_relative 'car_manager'
require_relative 'scoreboard'
require "gosu"
class GameWindow < Gosu::Window
  def initialize
    super 600, 600
    self.caption = "Ruby Turtle Game"

    @player = Player.new
    @car_manager = CarManager.new
    @scoreboard = Scoreboard.new
    @game_is_on = true
  end

  def update
    return unless @game_is_on

    @car_manager.generate_cars
    @car_manager.move_cars

    @car_manager.cars.each do |car|
      if Gosu.distance(@player.x, @player.y, car.x, car.y) < 12
        @scoreboard.game_over
        @game_is_on = false
      end
    end

    if @player.reached_finish?
      @player.reset_position
      @car_manager.increase_speed
      @scoreboard.increase_level
    end
  end

  def draw
    Gosu.draw_rect(0, 0, 600, 600, Gosu::Color::WHITE)
    @player.draw
    @car_manager.draw
    @scoreboard.draw
  end

  def button_down(id)
    case id
    when Gosu::KB_UP
      @player.move_up
    when Gosu::KB_DOWN
      @player.move_down
    end
  end
end

window = GameWindow.new
window.show
