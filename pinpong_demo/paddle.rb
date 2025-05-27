require 'ruby2d'

class Paddle < Rectangle ## Paddle class for the Pong game, representing the player's paddle
    BASE_SPEED = 2
    MAX_SPEED = 30
    FORCE = 0.4

    attr_accessor :speed, :start_x, :start_y

    def initialize(position)
        super(x: position[0], y: position[1], width: 20, height: 100, color: 'white') ## It inherits from Rectangle and has methods to move up and down, reset speed, and reset position
        @speed = BASE_SPEED
        @start_x = position[0]
        @start_y = position[1]
    end

    def move_up
        self.y -= @speed
        self.y = 0 if self.y < 0 ## Keep within top boundary
        increase_speed
    end

    def move_down
        self.y += @speed
        self.y = Window.height - self.height if self.y > Window.height - self.height ## Keep within bottom boundary
        increase_speed
    end

    def reset_speed
        @speed = BASE_SPEED
    end

    def increase_speed
        @speed += FORCE if @speed < MAX_SPEED
    end

    def reset_position
        self.x = @start_x
        self.y = @start_y
    end

end




