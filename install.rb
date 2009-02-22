# Install hook code here
def erb(t)
  ERB.new( File.open(t).read, 0, '<>' ).result
end

#Start building out models
puts "#{'Moving Modules Begin'.ljust(40,'-')}"

  #Create my instance variable to keep record of what I've done
@models = Hash.new
path = "#{File.dirname(__FILE__)}/../user_modules"

  #copy my modules
`ls #{path}`.split(/\n/).each do |f|
  puts "Copying #{f}"
  file = File.open("#{File.dirname(__FILE__)}/../../../../lib/#{f}", 'w')
  file.puts erb("#{path}/#{f}")
  file.close
end

puts "#{'Modules Finished'.ljust(40,'-')}"
puts
