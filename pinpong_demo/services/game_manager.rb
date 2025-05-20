class GameManager
  attr_reader :walls
  attr_accessor :game_over 

  def initialize(ball, l_paddle, r_paddle, scoreboard, score_view, ui)
    @ball = ball
    @l_paddle = l_paddle
    @r_paddle = r_paddle
    @scoreboard = scoreboard
    @score_view = score_view
    @ui = ui
    @walls = []
    @game_over = false 
  end

  def start_game
    @scoreboard.start
    show_all_movable_objects
  end

  def restart_game(num_walls, min_distance)
    @scoreboard.reset
    @score_view.update
    @score_view.show
    show_all_movable_objects
    @ball.reset_position
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

  def hide_all_movable_objects 
    @ball.color.opacity = 0
    @l_paddle.color.opacity = 0
    @r_paddle.color.opacity = 0
    @score_view.hide
  end

  def show_all_movable_objects
    @ball.color.opacity = 1
    @l_paddle.color.opacity = 1
    @r_paddle.color.opacity = 1
    @score_view.show
  end

  def update_score_view
    @score_view.update
  end
end