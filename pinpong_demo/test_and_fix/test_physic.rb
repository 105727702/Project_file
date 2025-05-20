module CollisionManager
  def self.handle_collisions(ball, l_paddle, r_paddle, walls)
    ## collision up/down
    if ball.y <= 0 || ball.y + ball.size >= Window.height
      ball.bounce_y
    end

    ## collision left paddle 
    if ball.x <= l_paddle.x + l_paddle.width &&
       ball.y + ball.size >= l_paddle.y &&
       ball.y <= l_paddle.y + l_paddle.height
      ball.x = l_paddle.x + l_paddle.width + 1
      ball.bounce_x
    end

    ## collision right paddle 
    if ball.x + ball.size >= r_paddle.x &&
       ball.y + ball.size >= r_paddle.y &&
       ball.y <= r_paddle.y + r_paddle.height
      ball.x = r_paddle.x - ball.size - 1
      ball.bounce_x
    end

    ## collision movement wall
    walls.each do |wall|
      wall.move
      if ball.x + ball.size >= wall.x &&
         ball.x <= wall.x + wall.width &&
         ball.y + ball.size >= wall.y &&
         ball.y <= wall.y + wall.height
        if ball.x < wall.x
          ball.x = wall.x - ball.size
        elsif ball.x > wall.x + wall.width
          ball.x = wall.x + wall.width
        end
        ball.bounce_x
      end
    end
  end
end

module CollisionManager
  def self.handle_collisions(ball, l_paddle, r_paddle, walls)
    ## collision up/down
    if ball.y <= 0 || ball.y + ball.size >= Window.height
      ball.bounce_y
    end

    ## collision left paddle 
    if ball.x <= l_paddle.x + l_paddle.width &&
       ball.y + ball.size >= l_paddle.y &&
       ball.y <= l_paddle.y + l_paddle.height
      ball.x = l_paddle.x + l_paddle.width + 1
      ball.bounce_x
      ball.accelerate(l_paddle.speed * 0.2, 0)  # Apply some of the paddle's speed
      ball.limit_speed(20) # Limit the ball's speed
    end

    ## collision right paddle 
    if ball.x + ball.size >= r_paddle.x &&
       ball.y + ball.size >= r_paddle.y &&
       ball.y <= r_paddle.y + r_paddle.height
      ball.x = r_paddle.x - ball.size - 1
      ball.bounce_x
      ball.accelerate(-r_paddle.speed * 0.2, 0)
      ball.limit_speed(20)
    end

    ## collision movement wall
    walls.each do |wall|
      wall.move
      if ball.x + ball.size >= wall.x &&
         ball.x <= wall.x + wall.width &&
         ball.y + ball.size >= wall.y &&
         ball.y <= wall.y + wall.height
        if ball.x < wall.x
          ball.x = wall.x - ball.size
        elsif ball.x > wall.x + wall.width
          ball.x = wall.x + wall.width
        end
        ball.bounce_x
      end
    end
  end
end