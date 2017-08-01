def substrings(str, dict)
  instances = dict.map { |e|  str.downcase.scan(e)}.reject { |e|  e.empty?}
  return Hash[instances.map {|row| [row[0], row.length]}]
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
p substrings("below", dictionary)
p substrings("Howdy partner, sit down! How's it going?", dictionary)
