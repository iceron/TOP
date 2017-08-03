require_relative 'player'

class Human < Player
  def generate_secret
    secret = []
    i = 0
    print "Available colors: "
    @@colors_list.each {|x| print x + " "}
    print "\n"
    while i < 4
      peg = nil
      while peg.nil?
        print "Enter color of slot #{i+1}: "
        choice = gets.chomp
        choice.downcase!
        if @@colors_list.any? {|color| color == choice}
          if secret.any? {|peg| peg.color == choice rescue false}
            puts "No duplicates allowed, try again."
          else
            peg = Peg.new(choice)
            secret << peg
          end
        else
          puts "Invalid input, try again."
        end
      end
      i = i + 1
    end
    secret
  end

  def breaker_input index
    print "Enter color at next slot ##{index}: "
    choice = gets.chomp
    return choice.downcase
  end

  def maker_input secret, data, index
    red = nil
    white = nil
    until red.is_a? Integer
      print "Enter number of slots with correct color and position: "
      red = Integer(gets) rescue nil
      puts "Invalid input, try again." if red.nil?
    end
    until white.is_a? Integer
      print "Enter number of slots with correct color but incorrect position: "
      white = Integer(gets) rescue nil
      puts "Invalid input, try again" if white.nil?
    end
    return red, white
  end
end
