class Scoreboard < Text
   attr_accessor :l_score, :r_score, :game_started

  def initialize
    reset
  end

  def l_point
    @l_score += 1
  end

  def r_point
    @r_score += 1
  end

  def start
    @game_started = true
  end

  def reset
    @l_score = 0
    @r_score = 0
    @game_started = false
  end
end