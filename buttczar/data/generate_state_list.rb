states = []
file = File.open(ARGV[0]).read
file.gsub!(/\r\n?/, "\n") # fix newlines to unix
file.each_line do |line|
  states << line.split(',')[1]
end
states.uniq! # remove duplicates
states.shift # remove the column header
states.sort!
states.each do |s|
  print '"' + s + '", '
end
puts ""
