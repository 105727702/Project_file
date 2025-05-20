require 'ruby2d'

class ScoreView
  def initialize(scoreboard)
    @scoreboard = scoreboard
    @text = Text.new("", x: 230, y: 20, size: 80, color: 'white')
    update
    hide
  end

  def update
    @text.text = "#{@scoreboard.l_score}           #{@scoreboard.r_score}"
  end

  def show
    @text.color.opacity = 1
  end

  def hide
    @text.color.opacity = 0
  end
end
