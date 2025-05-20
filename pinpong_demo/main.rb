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
require_relative "services/potion_effect" 

set title: "Pong", background: 'black', width: 800, height: 600

num_walls = 4
min_wall_distance = 60
num_effects = 3

ball = Ball.new
l_paddle = Paddle.new([30, 250])
r_paddle = Paddle.new([750, 250])
scoreboard = Scoreboard.new
score_view = ScoreView.new(scoreboard)
ui = UIRenderer.new
game_manager = GameManager.new(ball, l_paddle, r_paddle, scoreboard, score_view, ui)
walls = game_manager.generate_walls(num_walls, min_wall_distance)
potion_effect_manager = PotionEffect::PotionEffectManager.new(ball, l_paddle, r_paddle) # Khởi tạo PotionEffectManager

game_manager.hide_all_movable_objects
walls.each { |wall| wall.color.opacity = 0 }

keys_held = {
  up: false,
  down: false,
  w: false,
  s: false
}

def handle_game_over(winner, game_manager, ui, ball, l_paddle, r_paddle, walls)
  game_manager.game_over = true
  ui.show_winner(winner)
  ball.color.opacity = 0
  l_paddle.color.opacity = 0
  r_paddle.color.opacity = 0
  walls.each { |wall| wall.color.opacity = 0 }
end

on :key_down do |event|
  if event.key == "space"
    if !scoreboard.game_started
      game_manager.start_game
      ui.remove_start_texts
      walls.each { |wall| wall.color.opacity = 1 }
    elsif game_manager.game_over
      walls = game_manager.restart_game(num_walls, min_wall_distance)
      scoreboard.start
      game_manager.game_over = false
      ui.clear_winner_texts
    end
  else
    InputHandler.handle_key_down(event, keys_held)
  end
end

on :key_up do |event|
  InputHandler.handle_key_up(event, keys_held, l_paddle, r_paddle)
end

update do
  next unless scoreboard.game_started
  sleep 0.017 unless game_manager.game_over
  ball.move unless game_manager.game_over

  l_paddle.move_up if keys_held[:w] && !game_manager.game_over
  l_paddle.move_down if keys_held[:s] && !game_manager.game_over
  r_paddle.move_up if keys_held[:up] && !game_manager.game_over
  r_paddle.move_down if keys_held[:down] && !game_manager.game_over

  CollisionManager.handle_collisions(ball, l_paddle, r_paddle, walls, potion_effect_manager) unless game_manager.game_over # Truyền potion_effect_manager
  potion_effect_manager.update unless game_manager.game_over # Cập nhật hiệu ứng

  if ball.x < 0
    scoreboard.r_point
    game_manager.update_score_view
    ball.reset_position

    if scoreboard.r_score == 10
      handle_game_over(2, game_manager, ui, ball, l_paddle, r_paddle, walls)
    end
  elsif ball.x > Window.width
    scoreboard.l_point
    game_manager.update_score_view
    ball.reset_position

    if scoreboard.l_score == 10
      handle_game_over(1, game_manager, ui, ball, l_paddle, r_paddle, walls)
    end
  end
end

show