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
require_relative "services/sound_effect"

set title: "Pong", background: 'black', width: 800, height: 600

num_walls = 4 ## default number of walls
min_wall_distance = 60 ## default minimum distance between walls
ball = Ball.new
l_paddle = Paddle.new([30, 250])
r_paddle = Paddle.new([750, 250])
scoreboard = Scoreboard.new
score_view = ScoreView.new(scoreboard)
ui = UIRenderer.new
game_manager = GameManager.new(ball, l_paddle, r_paddle, scoreboard, score_view, ui)
walls = game_manager.generate_walls(num_walls, min_wall_distance)
potion_effect_manager = PotionEffect::PotionEffectManager.new(ball, l_paddle, r_paddle) 
game_started = false ## Flag to track if the game has started
game_manager.hide_all_movable_objects ## Hide all movable objects at the start
walls.each { |wall| wall.color.opacity = 0 } ## Set walls opacity to 0 at the start
sound = SoundEffect.new
sound.play_music(:menu)

keys_held = { ## Hash to track keys held down
  up: false,
  down: false,
  w: false,
  s: false
}

on :mouse_down do |event| ## Handle mouse click events  
  if !game_started  
    mx, my = event.x, event.y   ## Get mouse position
    if ui.showing_difficulty ## If the difficulty menu is showing ## Check if the mouse is on a difficulty option
      idx = ui.mouse_on_difficulty_option?(mx, my)
      if idx
        ui.selected_difficulty = idx  ## Update selected difficulty based on mouse position
        ui.highlight_difficulty
        ui.show_main_menu
      end
    else  
      if ui.mouse_on_start?(mx, my)  ## If the start button is clicked ## start the game
        case ui.selected_difficulty ## Set ball speed and velocity based on selected difficulty
        when 0  ## Easy difficulty
          ball.speed = 2
          ball.velocity = Vector.new(4, 4)
        when 1  ## Medium difficulty
          ball.speed = 3
          ball.velocity = Vector.new(7, 7)
        when 2  ## Hard difficulty
          ball.speed = 4
          ball.velocity = Vector.new(11, 11)
        end
        sound.stop_music
        walls = game_manager.restart_game(num_walls, min_wall_distance)
        game_manager.game_over = false  ## Reset game over state
        game_manager.start_game
        ui.remove_start_texts   ## Remove start texts from UI
        walls.each { |wall| wall.color.opacity = 1 }
        game_started = true
        scoreboard.game_started = true     
      elsif ui.mouse_on_exit?(mx, my)   ## If the exit button is clicked ## close the game
        close
      elsif ui.mouse_on_difficulty?(mx, my)   ## If the difficulty button is clicked  ## show the difficulty menu
        ui.show_difficulty_menu   ## Show the difficulty menu
      end
    end
  end
    if game_manager.game_over   ## If the game is over
      mx, my = event.x, event.y
    if ui.mouse_on_play_again?(mx, my) ## If the play again button is clicked ## restart the game
      walls = game_manager.restart_game(num_walls, min_wall_distance)
      scoreboard.start
      game_manager.game_over = false
      ui.clear_winner_texts
      game_started = true      
      scoreboard.game_started = true
      sound.stop_music
    elsif ui.mouse_on_back_menu?(mx, my)  ## If the back to main menu button is clicked ## go back to the main menu
      sound.stop_music
      sound.play_music(:menu)
      ui.clear_winner_texts
      ui.show_main_menu
      game_started = false
      scoreboard.game_started = false
      game_manager.hide_all_movable_objects
      walls.each { |wall| wall.color.opacity = 0 }
    end
  end
end

on :key_down do |event| ## Handle key down events
  InputHandler.handle_key_down(event, keys_held)
end

on :key_up do |event|   ## Handle key up events
  InputHandler.handle_key_up(event, keys_held, l_paddle, r_paddle)
end

update do
  next unless scoreboard.game_started   ## Skip update if the game has not started
  unless game_manager.game_over ## If the game is not over
    ball.move
    l_paddle.move_up if keys_held[:w]
    l_paddle.move_down if keys_held[:s]
    r_paddle.move_up if keys_held[:up]
    r_paddle.move_down if keys_held[:down]
    CollisionManager.handle_collisions(ball, l_paddle, r_paddle, walls, potion_effect_manager, sound) ## Handle collisions between ball, paddles, walls, and potion effects
    potion_effect_manager.update
  end

  if ball.x < 0 ## Check if the ball is out of bounds
    sound.play_effect(:ball_out)
    scoreboard.r_point
    game_manager.update_score_view
    ball.reset_position
    potion_effect_manager.active_effects.dup.each do |effect|   ## Remove all active potion effects
    potion_effect_manager.send(:remove_effect, effect.type) ## Remove the effect from the manager
    potion_effect_manager.active_effects.delete(effect) ## Delete the effect from the active effects list
  end
    game_manager.handle_game_over(2, game_manager, ui, ball, l_paddle, r_paddle, walls, sound) if scoreboard.r_score == 1
  
  elsif ball.x > Window.width ## Check if the ball is out of bounds 
    sound.play_effect(:ball_out)
    scoreboard.l_point
    game_manager.update_score_view
    ball.reset_position
    potion_effect_manager.active_effects.dup.each do |effect|   ## Remove all active potion effects
    potion_effect_manager.send(:remove_effect, effect.type) # Remove the effect from the manager
    potion_effect_manager.active_effects.delete(effect) ## Delete the effect from the active effects list
  end
    game_manager.handle_game_over(1, game_manager, ui, ball, l_paddle, r_paddle, walls, sound) if scoreboard.l_score == 1
  
  end
end

show



