class GameManager
  attr_reader :walls

  def initialize(ball, l_paddle, r_paddle, scoreboard, score_view, ui)
    @ball = ball
    @l_paddle = l_paddle
    @r_paddle = r_paddle
    @scoreboard = scoreboard
    @score_view = score_view
    @ui = ui
    @walls = []
  end

  def start_game
    @scoreboard.start
    @ball.color.opacity = 1
    @l_paddle.color.opacity = 1
    @r_paddle.color.opacity = 1
    @score_view.show
  end

  def restart_game(num_walls, min_distance)
    @scoreboard.reset
    @score_view.update
    @score_view.show

    @l_paddle.reset_position
    @r_paddle.reset_position
    @l_paddle.color.opacity = 1
    @r_paddle.color.opacity = 1

    @ball.reset_position
    @ball.color.opacity = 1

    @walls.each(&:remove)
    @walls = generate_walls(num_walls, min_distance)
    @walls.each { |wall| wall.color.opacity = 1 }

    @ui.clear_winner_texts
    return @walls 
  end

  def generate_walls(num_walls, min_distance)
    new_walls = []
    num_walls.times do
      attempts = 0
      begin
        x = rand(300..500)
        y = rand(50..500)
        attempts += 1
      end until Wall.valid_position(x, y, new_walls, min_distance) || attempts > 100
      new_walls << Wall.new(x, y) if attempts <= 100

    end
    new_walls
  end

  def hide_game_objects
    @ball.color.opacity = 0
    @l_paddle.color.opacity = 0
    @r_paddle.color.opacity = 0
    @score_view.hide
  end

  def update_score_view
    @score_view.update
  end

  def show_score_view
    @score_view.show
  end

  def hide_score_view
    @score_view.hide
  end

end