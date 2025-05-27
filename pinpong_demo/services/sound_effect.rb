class SoundEffect
  def initialize
    @music = {
      menu: '../sound_effect/game-background-1-321720.mp3',
      gameplay: '',
      gameover: ''
    }

    @effects = {
      ball_hit: '',
      wall_hit: '',
      paddle_hit: '',
      potion_effect: ''
    }

    @current_music = nil
  end

   def play_music(type)
    # stop_music
    file = @music[type]
    if file && File.exist?(file)
      @current_music = Music.new(file, loop: true)
      @current_music.play
    end
  end

  def stop_music
    @current_music&.stop
    @current_music = nil
  end

  def play_effect(effect)
    file = @effects[effect]
    Audio.new(file).play if file && File.exist?(file)
  end
end