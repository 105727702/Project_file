require 'ruby2d'

class UIRenderer
  attr_accessor :title_text, :instruction_text, :winner_text, :play_again_text

  def initialize
    @title_text = Text.new("Pong", x: 290, y: 200, size: 80, color: 'white')
    @instruction_text = Text.new("Press Space to Start", x: 200, y: 300, size: 40, color: 'white')
    @winner_text = nil
    @play_again_text = nil
  end

  def setting_game(ga)
    
  end

  def remove_start_texts
    @title_text.remove
    @instruction_text.remove
  end

  def show_winner(player)
    @winner_text = Text.new("Player #{player} Win", x: 280, y: 200, size: 40, color: 'white')
    @play_again_text = Text.new("Press Space to Play Again", x: 180, y: 300, size: 40, color: 'white')
  end

  def clear_winner_texts
    @winner_text&.remove
    @play_again_text&.remove
    @winner_text = nil
    @play_again_text = nil
  end
end