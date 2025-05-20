class Classname
  attr_accessor :name, :location

  def initialize(name, location)
    @name = name
    @location = location
  end
end

def read_track(a_file)
  track_name = a_file.gets&.chomp
  track_location = a_file.gets&.chomp
  Classname.new(track_name, track_location)
end

def print_track(record)
  puts("Track name: " + record.name)
  puts("Track location: " + record.location)
end

def main
  File.open("data.txt", "r") do |file|
    track = read_track(file)
    print_track(track)
  end
end

main

