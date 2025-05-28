require "ruby2d"
class SoundEffect
  def initialize
    
    @music = {
      menu: 'D:\Ruby_program\pinpong_demo\sound_effect\game-background-1-321720.mp3',
      gameover: 'D:\ruby_program\pinpong_demo\sound_effect\game-over-252897.mp3'
    }

    @effects = {
      ball_hit_wall: 'D:\Ruby_program\pinpong_demo\sound_effect\ping-82822 (mp3cut.net).mp3',
      wall_hit: 'D:\Ruby_program\pinpong_demo\sound_effect\ping-82822 (mp3cut.net).mp3',
      paddle_hit: 'D:\Ruby_program\pinpong_demo\sound_effect\metal-ping-192khz-86912.mp3',
      potion_effect: 'D:\Ruby_program\pinpong_demo\sound_effect\impact-sound-effect-240901.mp3'
    }

    @current_music = nil
  end

   def play_music(type)
    stop_music ## Stop any currently playing music
    file = @music[type]
    if file && File.exist?(file)
      @current_music = Music.new(file, loop: true)
      @current_music.volume = 30 ## Set the volume to 50%
      @current_music.play
    end
  end

  def stop_music 
    @current_music&.stop 
    @current_music = nil
  end

  def play_effect(effect)
    file = @effects[effect]
    Sound.new(file).play if file && File.exist?(file)
  end
end