require 'ruby2d'

class UIRenderer # This class is responsible for rendering the user interface elements in the Pong game
  include Ruby2D::DSL  # Include Ruby2D DSL for easy access to drawing methods

  # Define text elements used in the UI
  attr_accessor :title_text, :start_text, :difficulty_text, :difficulty_texts, :exit_text, :winner_text, :play_again_text, :selected_difficulty, :showing_difficulty

  def initialize
    @title_text = Text.new("Pong", x: 320, y: 120, size: 80, color: 'white')
    @start_text = Text.new("Start", x: 370, y: 250, size: 40, color: 'white')
    @difficulty_text = Text.new("Difficulty", x: 340, y: 320, size: 40, color: 'white')
    @difficulty_texts = []
    @exit_text = Text.new("Exit", x: 380, y: 390, size: 40, color: 'white')
    @winner_text = nil
    @play_again_text = nil
    @selected_difficulty = 0
    @showing_difficulty = false
    highlight_difficulty
  end

  def show_main_menu
    @title_text.add
    @start_text.add
    @difficulty_text.add
    @exit_text.add
    @difficulty_texts.each(&:remove)
    @showing_difficulty = false
  end

  def show_difficulty_menu
    @start_text.remove
    @exit_text.remove
    @difficulty_text.remove
    @difficulty_texts.each(&:remove)
    @difficulty_texts = [
      Text.new("Easy", x: 370, y: 250, size: 40, color: 'yellow'),
      Text.new("Medium", x: 370, y: 310, size: 40, color: 'white'),
      Text.new("Hard", x: 370, y: 370, size: 40, color: 'white')
    ]
    highlight_difficulty
    @showing_difficulty = true
  end

  def highlight_difficulty
    @difficulty_texts.each_with_index do |text, idx|
      text.color = (idx == @selected_difficulty ? 'yellow' : 'white')
    end
  end

  def remove_start_texts
    @title_text.remove
    @start_text.remove
    @difficulty_text.remove
    @difficulty_texts.each(&:remove)
    @exit_text.remove
  end

  def show_winner(player)
    @winner_text = Text.new("Player #{player} Win", x: 285, y: 200, size: 40, color: 'white')
    @play_again_text = Text.new("Play again", x: 320, y: 270, size: 36, color: 'yellow')
    @back_menu_text = Text.new("Back to main menu", x: 270, y: 330, size: 32, color: 'white')
  end

  def clear_winner_texts
    @winner_text&.remove
    @play_again_text&.remove
    @back_menu_text&.remove
    @winner_text = nil
    @play_again_text = nil
    @back_menu_text = nil
  end

  def mouse_on_play_again?(mouse_x, mouse_y)  ## Check if the mouse is on the "Play again" text
    @play_again_text && @play_again_text.text && @play_again_text.text != "" &&
    mouse_x.between?(@play_again_text.x, @play_again_text.x + @play_again_text.width) &&
    mouse_y.between?(@play_again_text.y, @play_again_text.y + @play_again_text.height)
  end

  def mouse_on_back_menu?(mouse_x, mouse_y) ## Check if the mouse is on the "Back to main menu" text
    @back_menu_text && @back_menu_text.text && @back_menu_text.text != "" &&
      mouse_x.between?(@back_menu_text.x, @back_menu_text.x + @back_menu_text.width) &&
      mouse_y.between?(@back_menu_text.y, @back_menu_text.y + @back_menu_text.height)
  end

  def mouse_on_start?(mouse_x, mouse_y) ## Check if the mouse is on the "Start" text
    @start_text && @start_text.text && @start_text.text != "" &&
      mouse_x.between?(@start_text.x, @start_text.x + @start_text.width) &&
      mouse_y.between?(@start_text.y, @start_text.y + @start_text.height)
  end

  def mouse_on_exit?(mouse_x, mouse_y) ## Check if the mouse is on the "Exit" text
    @exit_text && @exit_text.text && @exit_text.text != "" &&
      mouse_x.between?(@exit_text.x, @exit_text.x + @exit_text.width) &&
      mouse_y.between?(@exit_text.y, @exit_text.y + @exit_text.height)
  end

  def mouse_on_difficulty?(mouse_x, mouse_y) ## Check if the mouse is on the "Difficulty" text
    @difficulty_text && @difficulty_text.text && @difficulty_text.text != "" &&
      mouse_x.between?(@difficulty_text.x, @difficulty_text.x + @difficulty_text.width) &&
      mouse_y.between?(@difficulty_text.y, @difficulty_text.y + @difficulty_text.height)
  end

  def mouse_on_difficulty_option?(mouse_x, mouse_y) ## Check if the mouse is on any difficulty option
    @difficulty_texts.each_with_index do |text, idx|
      if mouse_x.between?(text.x, text.x + text.width) &&
         mouse_y.between?(text.y, text.y + text.height)
        return idx
      end
    end
    nil
  end
end