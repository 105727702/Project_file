module InputHandler
  def self.handle_key_down(event, keys_held)
    case event.key
    when 'up'   then keys_held[:up] = true
    when 'down' then keys_held[:down] = true
    when 'w'    then keys_held[:w] = true
    when 's'    then keys_held[:s] = true
    end
  end

  def self.handle_key_up(event, keys_held, l_paddle, r_paddle)
    case event.key
    when 'up'
      keys_held[:up] = false
      r_paddle.reset_speed
    when 'down'
      keys_held[:down] = false
      r_paddle.reset_speed
    when 'w'
      keys_held[:w] = false
      l_paddle.reset_speed
    when 's'
      keys_held[:s] = false
      l_paddle.reset_speed
    end
  end
end
