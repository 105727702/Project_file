class Scoreboard
  def initialize
    @level = 1
    @font = Gosu::Font.new(24)
    @game_over = false
  end

  def increase_level
    @level += 1
  end

  def game_over
    @game_over = true
  end

  def draw
    @font.draw_text("Level: #{@level}", 10, 10, 1, 1, 1, Gosu::Color::BLACK)
    if @game_over
      @font.draw_text("Game Over", 250, 280, 1, 1, 1, Gosu::Color::RED)
    end
  end
end
