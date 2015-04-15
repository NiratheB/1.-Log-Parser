def correctUri?(uri, correct_uri)
  if uri== correct_uri
    return true
  end
end

def isPost?(query)
  if query=="P"
    return true
  end
end

# read file
dir = "/home/behtarin/Downloads"
filename = "therap.log.ms-2.2013-10-21"
URI = "/ma/logbook/view"

frequency_post = Hash.new(0)
frequency_get = Hash.new(0)

duration_post = Hash.new(0)
duration_get = Hash.new(0)

begin

#read file
file = File.new(dir+"/"+filename,"r")

format_expression = /\d+[-\/]\d+[-\/]\d+ (\d+)[:-]\d+[:-]\d+,.*URI=\[(.*)\].*([PG]),.*time=(\d+)ms/

#for each line
while line= file.gets
  #check format
  if line =~ format_expression
    #check uri
    hour = $1.to_i
    uri = $2
    query_type = $3
    time = $4
    if correctUri?(uri,URI)
      #if Post
      if isPost?(query_type)
        #get Time
        frequency_post[hour]+=1
        duration_post[hour]+=time.to_i
      else
        frequency_get[hour]+=1
        duration_get[hour]+=time.to_i
      end
    end
  end
end
file.close

#show output
format="%15s\t%15s\t%15s\t%15s\t%15s\n"
printf(format, "Time Slot", "Get Frequency", "Get Duration/ms", "Post Frequency", "Post Duration/ms")
printf(format, "----", "-------", "---------", "-------", "---------")
(0...24).each do |slot|
  printf(format,"#{slot}-#{slot+1}", "#{frequency_get[slot]}", "#{duration_get[slot]}", "#{frequency_post[slot]}", "#{duration_post[slot]}")
  
end

rescue Exception
  puts "No such file!"
end

