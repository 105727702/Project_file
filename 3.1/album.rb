require_relative './input_functions'

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

Genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
  attr_accessor :name, :artist, :genre
end

def read_album()
  puts "Enter Album"
  album_name = read_string("Enter Album name:")
  album_artist = read_string("Enter artist name:")
  puts "Enter Genre between 1 - 4:"
  get_genre_number = gets.to_i
  album = Album.new()
  album.name = album_name
  album.artist = album_artist
  album.genre = get_genre_number
  return album
end

# Takes a single album and prints it to the terminal 
# complete the missing lines:

def print_album(album)
  puts('Album information is: ')
	# insert lines here
  puts(album.name)
	puts(album.artist)
  puts("Genre is" + " " + album.genre.to_s)
  puts(Genre_names[album.genre.to_i]) # we will cover this in Week 6!
end

# Reads in an Album then prints it to the terminal

def main()
	album = read_album()
	print_album(album)
end

main()


