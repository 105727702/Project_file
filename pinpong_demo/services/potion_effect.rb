module PotionEffect
  class Effect
    attr_reader :type, :start_time, :duration

    def initialize(type, duration)
      @type = type
      @start_time = Time.now
      @duration = duration
    end

    def active?
      Time.now - @start_time < @duration
    end
  end

  class PotionEffectManager
    attr_reader :active_effects

    def initialize(ball, l_paddle, r_paddle)
      @ball = ball
      @l_paddle = l_paddle
      @r_paddle = r_paddle
      @active_effects = []
      @original_ball_speed = ball.speed
      @original_paddle_height = l_paddle.height 
    end

    def apply_random_effects(num_effects = 3, duration = 10)
      available_effects = [:increase_speed_ball, :enlarge_paddle, :slow_down_ball]
      
      num_effects.times do
        effect_type = available_effects.sample
        unless @active_effects.any? { |effect| effect.type == effect_type }
          @active_effects << Effect.new(effect_type, duration)
          apply_effect(effect_type)
        end
      end
    end

    def update
      @active_effects.each do |effect|
        unless effect.active?
          remove_effect(effect.type)
          @active_effects.delete(effect)
        end
      end
    end

    private

    def apply_effect(type)
      case type
      when :increase_speed_ball
        @ball.speed += 2 
        @ball.velocity.x = (@ball.velocity.x / @ball.velocity.magnitude) * @ball.speed
        @ball.velocity.y = (@ball.velocity.y / @ball.velocity.magnitude) * @ball.speed
      when :enlarge_paddle
        @l_paddle.height = 150
        @r_paddle.height = 150
        @l_paddle.y -= 25 
        @r_paddle.y -= 25
      when :slow_down_ball
        @ball.speed = 3 
        @ball.velocity.x = (@ball.velocity.x / @ball.velocity.magnitude) * @ball.speed
        @ball.velocity.y = (@ball.velocity.y / @ball.velocity.magnitude) * @ball.speed
      end
    end

    def remove_effect(type)
      case type
      when :increase_speed_ball
        @ball.speed = @original_ball_speed
        @ball.velocity.x = (@ball.velocity.x / @ball.velocity.magnitude) * @ball.speed
        @ball.velocity.y = (@ball.velocity.y / @ball.velocity.magnitude) * @ball.speed
      when :enlarge_paddle
        @l_paddle.height = @original_paddle_height
        @r_paddle.height = @original_paddle_height
        @l_paddle.y += 25
        @r_paddle.y += 25
      when :slow_down_ball
        @ball.speed = @original_ball_speed
        @ball.velocity.x = (@ball.velocity.x / @ball.velocity.magnitude) * @ball.speed
        @ball.velocity.y = (@ball.velocity.y / @ball.velocity.magnitude) * @ball.speed
      end
    end
  end
end
 

  

