
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Track
    attr_accessor :name, :location, :duration

    def initialize(name, location, duration)
        @name = name
        @location = location
        @duration = duration
    end
end

class Album
    attr_accessor :title, :artist, :genre, :tracks, :year

    def initialize(title, artist, genre, tracks, year)
        @title = title
        @artist = artist
        @genre = genre
        @tracks = tracks
        @year = year
    end
end

$albums = []
$playlist = Album.new("Playlist", "Various", 0, [], "N/A")

def read_track(music_file)
    name = music_file.gets&.chomp
    location = music_file.gets&.chomp
    duration = music_file.gets&.chomp
    Track.new(name, location, duration)
end

def read_tracks(music_file)
    count = music_file.gets.to_i
    tracks = []
    count.times do
        tracks << read_track(music_file)
    end
    tracks
end

def read_album(music_file)
    artist = music_file.gets&.chomp
    title = music_file.gets&.chomp
    year = music_file.gets&.chomp
    genre = music_file.gets.to_i
    tracks = read_tracks(music_file)
    Album.new(title, artist, genre, tracks, year)
end

def list_all_tracks
    all_tracks = []
    $albums.each_with_index do |album, album_idx|
        album.tracks.each_with_index do |track, track_idx|
            all_tracks << { track: track, album: album, album_idx: album_idx, track_idx: track_idx }
        end
    end
    all_tracks
end

def read_albums_from_file
    print "Enter filename: "
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

def print_track(track)
    puts "Track title: #{track.name}"
    puts "File location: #{track.location}"
    puts "Duration: #{track.duration}"
end

def print_tracks(tracks)
    tracks.each_with_index do |track, idx|
        puts "Track #{idx + 1}:"
        print_track(track)
    end
end

def print_album(album)
    puts "Album title: #{album.title}"
    puts "Artist: #{album.artist}"
    puts "Year: #{album.year}"
    puts "Genre: #{$genre_names[album.genre]}"
    puts "Tracks:"
    print_tracks(album.tracks)
end

def display_albums
    if $albums.empty?
        puts "No albums loaded."
    else
        $albums.each_with_index do |album, idx|
            puts "\nAlbum #{idx + 1}:"
            print_album(album)
        end
    end
end

def select_album_to_play
    if $albums.empty?
        puts "No albums loaded."
        return
    end
    puts "Select an album to play:"
    $albums.each_with_index do |album, idx|
        puts "#{idx + 1}. #{album.title} by #{album.artist}"
    end
    print "Enter album number: "
    choice = gets.to_i
    if choice.between?(1, $albums.size)
        puts "Playing album:"
        print_album($albums[choice - 1])
    else
        puts "Invalid selection."
    end
end

def add_to_playlist_menu
    if $albums.empty?
        puts "No albums loaded."
        return
    end

    all_tracks = list_all_tracks
    if all_tracks.empty?
        puts "No tracks available."
        return
    end

    puts "All tracks:"
    all_tracks.each_with_index do |entry, idx|
        puts "#{idx + 1}. #{entry[:track].name} (#{entry[:album].title} by #{entry[:album].artist})"
    end
    print "Enter track number to add to playlist (or 0 to cancel): "
    choice = gets.to_i
    if choice.between?(1, all_tracks.size)
        selected_track = all_tracks[choice - 1][:track]
        $playlist.tracks << selected_track
        puts "Added '#{selected_track.name}' to playlist."
    else
        puts "Cancelled or invalid selection."
    end
end

def display_playlist
    if $playlist.tracks.empty?
        puts "Playlist is empty."
    else
        puts "\nPlaylist:"
        print_tracks($playlist.tracks)
    end
end

def menu
    loop do
        puts "\nMenu:"
        puts "1. Read in Albums"
        puts "2. Display Albums"
        puts "3. Select an Album to play"
		puts "4. Add to Playlist"
        puts "5. Exit the application"
        print "Enter your choice: "
        choice = gets.chomp
        case choice
        when "1"
            read_albums_from_file
        when "2"
            display_albums
        when "3"
            select_album_to_play
				when "4"
            add_to_playlist_menu
            display_playlist
        when "5"
            puts "Exiting."
            break
        else
            puts "Invalid option."
        end
    end
end
