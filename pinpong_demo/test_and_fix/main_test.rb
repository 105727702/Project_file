require 'ruby2d'
require_relative "paddle"
require_relative "scoreboard"
require_relative "ball"
require_relative "random_wall"
require_relative "services/input_handler"
require_relative "services/collision_manager"
require_relative "services/ui_renderer"
require_relative "services/game_manager"
require_relative "services/score_view"
## create object
set title: "Pong", background: 'black', width: 800, height: 600

num_walls = 4
min_wall_distance = 60 ## Minimum distance between walls

ball = Ball.new
l_paddle = Paddle.new([30, 250])
r_paddle = Paddle.new([750, 250])
scoreboard = Scoreboard.new
score_view = ScoreView.new(scoreboard)
ui = UIRenderer.new
game_manager = GameManager.new(ball, l_paddle, r_paddle, scoreboard, score_view, ui)
walls = game_manager.generate_walls(num_walls, min_wall_distance)
game_manager.hide_game_objects
walls.each { |wall| wall.color.opacity = 0 } ## too much bug here ==((

## paddle continuos move when held in key
keys_held = {
  up: false,
  down: false,
  w: false,
  s: false
}



on :key_down do |event|
  if event.key == "space" && !scoreboard.game_started
    game_manager.start_game
    ui.remove_start_texts
    walls.each { |wall| wall.color.opacity = 1 }
  elsif @game_over && event.key == "space"
    walls = game_manager.restart_game(num_walls, min_wall_distance)
    scoreboard.start  
    @game_over = false
    ui.clear_winner_texts


  else
    InputHandler.handle_key_down(event, keys_held)
  end
end

on :key_up do |event|
  InputHandler.handle_key_up(event, keys_held, l_paddle, r_paddle)
end


## when the ball not out
update do
  unless scoreboard.game_started
    next
  end
  sleep 0.017 unless @game_over
  ball.move unless @game_over
## paddle increase speed when held in key for a period
  ## Left Paddle Movement and Boundary Check
    if keys_held[:w] && unless @game_over
        l_paddle.move_up
    end
  end

    if keys_held[:s] && unless @game_over
        l_paddle.move_down
    end
  end
    ## Right Paddle Movement and Boundary Check
    if keys_held[:up] && unless @game_over
        r_paddle.move_up
    end
  end
    if keys_held[:down] && unless @game_over
        r_paddle.move_down
    end
  end