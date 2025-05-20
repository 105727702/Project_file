def take_array(data)
  result = 0
  i = 0
  while i < data.length 
      result += data[ i ].to_i
      i += 1
  end
  return result
end

data_1 = ["6", "-3", "3", "8", "1"]
data_2 = ["2", "6", "-2", "3"]
puts(take_array(data_1))
puts(take_array(data_2))