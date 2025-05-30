class GameManager ##  Manages the game state, including ball, paddles, scoreboard, and walls
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

  def handle_game_over(winner, game_manager, ui, ball, l_paddle, r_paddle, walls, sound) ## Handle game over appearance logic
    @game_over = true
    ui.show_winner(winner)
    @ball.color.opacity = 0
    @l_paddle.color.opacity = 0
    @r_paddle.color.opacity = 0
    @walls.each { |wall| wall.color.opacity = 0 }
    sound.stop_music 
    sound.play_music(:gameover) 
  end

  def restart_game(num_walls, min_distance)   ## Restart the game with a specified number of walls and a minimum distance between them
    @scoreboard.reset
    @score_view.update
    @score_view.show
    show_all_movable_objects
    @ball.reset_position
    @l_paddle.reset_position
    @r_paddle.reset_position
    @walls.each(&:remove)
    @walls = generate_walls(num_walls, min_distance)
    @walls.each { |wall| wall.color.opacity = 1 }
    @ui.clear_winner_texts
    return @walls
  end

  def generate_walls(num_walls, min_distance) ## Generate walls with a minimum distance between them
    new_walls = []
    col_width = (Window.width - 400) / num_walls
    x_positions = []
    num_walls.times do |i|
    x = 200 + i * col_width + col_width / 2
    x_positions << x
  end

    x_positions.each do |x|
      attempts = 0
      begin
        y = rand(50..(Window.height - Wall::WALL_HEIGHT - 50))
        attempts += 1
      end until new_walls.none? { |w| (w.y - y).abs < min_distance } || attempts > 100
      new_walls << Wall.new(x, y) if attempts <= 100
    end
    new_walls
  end

  def hide_all_movable_objects  ## Hide all movable objects in the game
    @ball.color.opacity = 0
    @l_paddle.color.opacity = 0
    @r_paddle.color.opacity = 0
    @score_view.hide
  end

  def show_all_movable_objects  ## Show all movable objects in the game
    @ball.color.opacity = 1
    @l_paddle.color.opacity = 1
    @r_paddle.color.opacity = 1
    @score_view.show
  end

  def update_score_view   ## Update the score view with the current scores
    @score_view.update
  end
end

