module CollisionManager   ## Module for managing collisions in the game
  ## Check if two rectangles collide (AABB collision)
  ## Algorithm: Compare the position and size of the two rectangles on both the X and Y axes.
  def self.check_collision(rect1, rect2)
    rect1.x < rect2.x + rect2.width &&
      rect1.x + rect1.width > rect2.x &&
      rect1.y < rect2.y + rect2.height &&
      rect1.y + rect1.height > rect2.y 
  end
  ## Resolve collision between ball and object
  ## Idea: Calculate the overlap on each axis, then push the ball away from the object in the direction of the least overlap. 
  ## Then, reflect the ball's velocity based on the normal vector of the collision surface.
  def self.resolve_collision(ball, object, normal = Vector.new(0,0)) ## Resolve collision between ball and object
    
    ## Calculate the distance between the centers of the ball and the object
    dx = (ball.x + ball.size / 2) - (object.x + object.width / 2)
    dy = (ball.y + ball.size / 2) - (object.y + object.height / 2)
    
    ## Calculate the overlap on each axis
    half_ball_width = ball.size / 2
    half_ball_height = ball.size / 2
    half_object_width = object.width / 2
    half_object_height = object.height / 2
    
    overlap_x = half_ball_width + half_object_width - dx.abs
    overlap_y = half_ball_height + half_object_height - dy.abs
    
    ## Push the ball away from the object along the axis with a smaller overlap.
    if overlap_x >= overlap_y ## Resolve vertical collision
      if dy < 0
        ball.y -= overlap_y ## Reflection along the Y axis
        normal.x = 0
        normal.y = 1
      else
        ball.y += overlap_y
        normal.x = 0
        normal.y = -1
      end
    else ## Resolve horizontal collision
      if dx < 0
        ball.x -= overlap_x ## Reflection along the X axis
        normal.x = 1
        normal.y = 0
      else
        ball.x += overlap_x 
        normal.x = -1
        normal.y = 0
      end
    end
    ball.bounce(normal)
  end

  ## Handle all collisions in the game
  ## Includes: collision with the window frame, paddle, moving wall
  def self.handle_collisions(ball, l_paddle, r_paddle, walls, potion_effect_manager, sound = nil)  ## Handle all collisions in the game
    ## Collisions with window boundaries
    if ball.y <= 0
      ball.y = 0
      ball.bounce(Vector.new(0, 1))  ## Reflection along the Y axis
      sound&.play_effect(:wall_hit)
    elsif ball.y + ball.size >= Window.height
      ball.y = Window.height - ball.size
      ball.bounce(Vector.new(0, -1))
      sound&.play_effect(:wall_hit)
    end

    ## Collisions with paddles
    if check_collision(ball, l_paddle)
      resolve_collision(ball, l_paddle, Vector.new(1, 0))
      ball.accelerate(l_paddle.speed * 0.2, 0)
      ball.limit_speed(20)
      sound&.play_effect(:paddle_hit)
      if rand < 0.5
        potion_effect_manager.apply_random_effects(3, 6, sound) 
      end
    elsif check_collision(ball, r_paddle)
      resolve_collision(ball, r_paddle, Vector.new(-1, 0))
      ball.accelerate(-r_paddle.speed * 0.2, 0)
      ball.limit_speed(20)
      sound&.play_effect(:paddle_hit)
      if rand < 0.5
        potion_effect_manager.apply_random_effects(3, 6, sound) 
      end
    end

    ## Collisions with walls
    walls.each do |wall|
      wall.move
      if check_collision(ball, wall)
        resolve_collision(ball, wall)
        sound&.play_effect(:ball_hit_wall)
        # if rand < 0.5
        #   potion_effect_manager.apply_random_effects(3, 6, sound) 
        # end
      end
    end
  end
end






