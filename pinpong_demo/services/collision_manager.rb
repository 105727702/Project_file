module CollisionManager
  def self.check_collision(rect1, rect2)
    rect1.x < rect2.x + rect2.width &&
      rect1.x + rect1.width > rect2.x &&
      rect1.y < rect2.y + rect2.height &&
      rect1.y + rect1.height > rect2.y
  end

  def self.resolve_collision(ball, object, normal = Vector.new(0,0))
    # Calculate overlap on each axis
    dx = (ball.x + ball.size / 2) - (object.x + object.width / 2)
    dy = (ball.y + ball.size / 2) - (object.y + object.height / 2)
    
    half_ball_width = ball.size / 2
    half_ball_height = ball.size / 2
    half_object_width = object.width / 2
    half_object_height = object.height / 2
    
    overlap_x = half_ball_width + half_object_width - dx.abs
    overlap_y = half_ball_height + half_object_height - dy.abs
    
    if overlap_x >= overlap_y # Resolve vertical collision
      if dy < 0
        ball.y -= overlap_y
        normal.x = 0
        normal.y = 1
      else
        ball.y += overlap_y
        normal.x = 0
        normal.y = -1
      end
    else # Resolve horizontal collision
      if dx < 0
        ball.x -= overlap_x
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

  def self.handle_collisions(ball, l_paddle, r_paddle, walls, potion_effect_manager) # Thêm potion_effect_manager
    # Collisions with window boundaries
    if ball.y <= 0
      ball.y = 0
      ball.bounce(Vector.new(0, 1))
    elsif ball.y + ball.size >= Window.height
      ball.y = Window.height - ball.size
      ball.bounce(Vector.new(0, -1))
    end

    # Collisions with paddles
    if check_collision(ball, l_paddle)
      resolve_collision(ball, l_paddle, Vector.new(1, 0))
      ball.accelerate(l_paddle.speed * 0.2, 0)
      ball.limit_speed(20)
    elsif check_collision(ball, r_paddle)
      resolve_collision(ball, r_paddle, Vector.new(-1, 0))
      ball.accelerate(-r_paddle.speed * 0.2, 0)
      ball.limit_speed(20)
    end

    # Collisions with walls
    walls.each do |wall|
      wall.move
      if check_collision(ball, wall)
        resolve_collision(ball, wall)
        potion_effect_manager.apply_random_effects(3, 10) # Kích hoạt hiệu ứng khi va chạm
      end
    end
  end
end