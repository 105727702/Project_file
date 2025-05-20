require_relative "./input_functions"
# put your code below
class Classname
  attr_accessor :name, :location
  def initialize(name, location)
    @name = name
    @location = location
  end
end

def read_track
  puts("[User@sahara ~]$ ruby_track_terminal_answer.rb")
  track_name = read_string("Enter track name: ")
  track_location = read_string("Enter track location: ")
  record = Classname.new(track_name, track_location)
  return record
end

def print_track(record)
  puts("Track name:" + " " + record.name)
  puts("Track location:" + " " + record.location)
end

def main()
  record = read_track()
  print_track(record)
end

main()
