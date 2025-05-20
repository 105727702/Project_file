def main()
  puts ("Please enter your title: (Mr, Mrs, Ms, Miss, Dr)")
  title = gets()
  title = title.chomp()
  puts ("Please enter your first name: ")
  first_name = gets()
  first_name = first_name.chomp()
  puts ("Please enter your last name: ")
  last_name = gets()
  last_name = last_name.chomp()
  puts ("Please enter the house or unit number: ")
  unit_number = gets()
  unit_number = unit_number.chomp()
  puts ("Please enter the street name: ")
  street_name = gets()
  street_name = street_name.chomp()
  puts ("Please enter the suburb: ")
  suburb = gets()
  suburb = suburb.chomp()
    process = true
    while process do
    puts ("Please enter a postcode (0000 - 9999): ")
    postcode = gets()
    postcode = postcode.chomp()
    postcode = postcode.to_i
      if postcode >= 0 && postcode <= 9999
        process = false
      else
        puts ("please enter the valid number again")
      end
    end
  puts ("Please enter your message subject line: ")
  message = gets()
  message = message.chomp()
  puts ("Please enter your message content: ")
  content = gets()
  puts (title + " " + first_name + " " + last_name \n unit_number + " " + street_name \n suburb + " " + postcode \n "RE: " + message \n\n content)
end
main()

