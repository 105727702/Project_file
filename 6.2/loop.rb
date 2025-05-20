class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# Returns an array of tracks read from the given file
def read_tracks(a_file)

  count = a_file.gets().to_i()
  tracks = Array.new()
  # Put a while loop here which increments an index to read the tracks
  while tracks.length < count
    track = read_track(a_file)
    tracks << track
  end

  return tracks
end

# reads in a single track from the given file.
def read_track(a_file)
  # complete this function
	# you need to create a Track here.
  track_name = a_file.gets&.chomp
  track_location = a_file.gets&.chomp
  return Track.new(track_name, track_location)
end


# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
  i = 0
  while i < tracks.length 
    print_track(tracks[i])
    i += 1
  end
  # Use a while loop with a control variable index
  # to print each track. Use tracks.length to determine how
  # many times to loop.

  # Print each track use: tracks[index] to get each track record
end

# Takes a single track and prints it to the terminal
def print_track(tracks)
  puts(tracks.name)
	puts(tracks.location)
end

# Open the file and read in the tracks then print them
def main()
  a_file = File.new("input.txt", "r") # open for reading
  # Print all the tracks
  tracks = read_tracks(a_file)
  a_file.close()
  print_tracks(tracks)
end

main()