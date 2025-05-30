require 'rubygems'
require 'gosu'
require_relative 'album_file_handling'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

TrackLeftX = 30
TrackTopY = 100
TrackSpacing = 40

PLAYER_PANEL_Y = 600

class MusicPlayerMain < Gosu::Window
  def initialize
    super 1000, 800
    self.caption = "Music Player"
    @track_font = Gosu::Font.new(24)
    @small_font = Gosu::Font.new(18)
    @big_font = Gosu::Font.new(32)
    @volume = 1.0
    @dragging_volume = false 
    if $albums.empty?
      begin
        file = File.open("album.txt", "r")
        num_albums = file.gets.to_i
        $albums.clear
        num_albums.times do
          $albums << read_album(file)
        end
        file.close
        puts "#{num_albums} album(s) loaded."
      rescue
        puts "Could not open file."
      end
    end
    @playlist = $playlist
    @selected_track = nil
    @song = nil
    @playing = false
    @albums = $albums
    @cover_images = {} 
    load_album_covers

    if @playlist.tracks.empty? && !$albums.empty?
      $albums.each do |album|
        album.tracks.each do |track|
          @playlist.tracks << track
        end
      end
    end
  end

  def load_album_covers
    @default_cover = Gosu::Image.new("default_cover.jpg", retro: false) rescue nil
  end

  def draw_background
    draw_quad(
      0, 0, Gosu::Color::BLACK,
      width, 0, Gosu::Color::BLACK,
      0, height, Gosu::Color::BLACK,
      width, height, Gosu::Color::BLACK,
      ZOrder::BACKGROUND
    )
  end

  def draw_playlist_panel
    @big_font.draw("Playlist", TrackLeftX, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
    if @playlist.tracks.empty?
      @track_font.draw("Playlist is empty.", TrackLeftX, TrackTopY, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    else
      @playlist.tracks.each_with_index do |track, idx|
        y = TrackTopY + idx * TrackSpacing
        color = (@selected_track == idx) ? Gosu::Color::AQUA : Gosu::Color::WHITE
        @track_font.draw("#{idx + 1}. #{track.name}", TrackLeftX, y, ZOrder::PLAYER, 1.0, 1.0, color)
      end
    end
  end

  def draw_player_panel
    return unless @selected_track
    track = @playlist.tracks[@selected_track]
    album = find_album_of_track(track)
    artist_img = artist_image_for(track, album)
    artist_img&.draw(550, PLAYER_PANEL_Y - 400, ZOrder::PLAYER, 1.5, 1.5)

    @track_font.draw("#{track.name}", 600, PLAYER_PANEL_Y - 60, ZOrder::UI, 1.2, 1.2, Gosu::Color::WHITE)
    @small_font.draw("Artist: #{album&.artist}", 600, PLAYER_PANEL_Y - 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::CYAN)
    @small_font.draw("Album: #{album&.title}", 600, PLAYER_PANEL_Y + 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    @small_font.draw("Genre: #{$genre_names[album&.genre.to_i]}", 600, PLAYER_PANEL_Y + 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::FUCHSIA)
    @small_font.draw("Duration: #{track.duration}", 600, PLAYER_PANEL_Y + 70, ZOrder::UI, 1.0, 1.0, Gosu::Color::GRAY)

    draw_player_controls
    draw_volume_slider
  end

 def draw_volume_slider
    x = 60
    y = PLAYER_PANEL_Y + 145
    width = 200
    height = 10

    draw_rect(x, y, width, height, Gosu::Color::GRAY, ZOrder::UI)

    # Đổi màu thanh volume thành đỏ
    draw_rect(x, y, width * @volume, height, Gosu::Color::RED, ZOrder::UI)

    knob_x = x + width * @volume
    knob_y = y + height / 2
    draw_circle(knob_x, knob_y, 12, Gosu::Color::WHITE, ZOrder::UI)

    @small_font.draw("Volume: #{(@volume * 100).to_i}%", x + width + 20, y - 8, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def draw_circle(cx, cy, r, color, z)
    32.times do |i|
      angle1 = 2 * Math::PI * i / 32
      angle2 = 2 * Math::PI * (i + 1) / 32
      x1 = cx + Math.cos(angle1) * r
      y1 = cy + Math.sin(angle1) * r
      x2 = cx + Math.cos(angle2) * r
      y2 = cy + Math.sin(angle2) * r
      draw_triangle(cx, cy, color, x1, y1, color, x2, y2, color, z)
    end
  end

  def draw_player_controls
   
    x = 600
    y = PLAYER_PANEL_Y + 120
    size = 40

    draw_triangle(x, y, Gosu::Color::WHITE, x, y + size, Gosu::Color::WHITE, x - size, y + size / 2, Gosu::Color::WHITE, ZOrder::UI)

    if @playing

      draw_rect(x + 60, y, 10, size, Gosu::Color::WHITE, ZOrder::UI)
      draw_rect(x + 80, y, 10, size, Gosu::Color::WHITE, ZOrder::UI)
    else

      draw_triangle(x + 60, y, Gosu::Color::WHITE, x + 60, y + size, Gosu::Color::WHITE, x + 100, y + size / 2, Gosu::Color::WHITE, ZOrder::UI)
    end
    
    draw_triangle(x + 140, y, Gosu::Color::WHITE, x + 140, y + size, Gosu::Color::WHITE, x + 180, y + size / 2, Gosu::Color::WHITE, ZOrder::UI)

    @small_font.draw("🔀", x + 220, y + 5, ZOrder::UI, 1.5, 1.5, Gosu::Color::GRAY)

    @small_font.draw("🔁", x + 260, y + 5, ZOrder::UI, 1.5, 1.5, Gosu::Color::GRAY)
  end

  def draw
    draw_background
    draw_playlist_panel
    draw_player_panel
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    if id == Gosu::MsLeft
      mouse_y = self.mouse_y
      mouse_x = self.mouse_x
      vol_x = 60
      vol_y = PLAYER_PANEL_Y + 145
      vol_width = 200
      vol_height = 20
      if mouse_x > vol_x && mouse_x < vol_x + vol_width && mouse_y > vol_y && mouse_y < vol_y + vol_height
        @dragging_volume = true
        update_volume_by_mouse(mouse_x)
        return
      end

      @playlist.tracks.each_with_index do |track, idx|
        y = TrackTopY + idx * TrackSpacing
        if mouse_x > TrackLeftX && mouse_x < TrackLeftX + 300 && mouse_y > y && mouse_y < y + TrackSpacing
          @selected_track = idx
          play_track(idx)
        end
      end

      x = 600
      y = PLAYER_PANEL_Y + 120
      size = 40
      prev_x1 = x - size
      prev_x2 = x
      prev_y1 = y
      prev_y2 = y + size
      if mouse_x > prev_x1 && mouse_x < prev_x2 && mouse_y > prev_y1 && mouse_y < prev_y2
        if @selected_track && @selected_track > 0
          @selected_track -= 1
          play_track(@selected_track)
        end
      end

      next_x1 = x + 140
      next_x2 = x + 180
      next_y1 = y
      next_y2 = y + size
      if mouse_x > next_x1 && mouse_x < next_x2 && mouse_y > next_y1 && mouse_y < next_y2
        if @selected_track && @selected_track < @playlist.tracks.size - 1
          @selected_track += 1
          play_track(@selected_track)
        end
      end

      play_x = 660  
      play_y = PLAYER_PANEL_Y + 120
      play_w = 50
      play_h = 40
      if mouse_x > play_x && mouse_x < play_x + play_w && mouse_y > play_y && mouse_y < play_y + play_h
        if @song
          if @playing
            @song.pause
            @playing = false
          else
            @song.play(false)
            @playing = true
          end
        end
      end
    end
  end

  def button_up(id)
    if id == Gosu::MsLeft
      @dragging_volume = false
    end
  end

  def update
    if @dragging_volume
      update_volume_by_mouse(self.mouse_x)
    end
  end

  def update_volume_by_mouse(mouse_x)
    vol_x = 60
    vol_width = 200
    rel = [[(mouse_x - vol_x).to_f / vol_width, 0.0].max, 1.0].min
    @volume = rel
    @song&.volume = @volume if @song
  end

  def play_track(idx)
    track = @playlist.tracks[idx]
    if File.exist?(track.location)
      @song = Gosu::Song.new(track.location)
      @song.volume = @volume
      @song.play(false)
      @playing = true
    else
      puts "File not found: #{track.location}"
      @playing = false
    end
  end

  def find_album_of_track(track)
    $albums.find { |album| album.tracks.include?(track) }
  end

  def artist_image_for(track, album)
    artist = album.artist.strip
    img_folder = "d:/Ruby_program/8.0/img_artist"
    jpg_path = File.join(img_folder, "#{artist}.jpg")
    if File.exist?(jpg_path)
      Gosu::Image.new(jpg_path)
    else
      @default_cover
    end
  end
end

MusicPlayerMain.new.show